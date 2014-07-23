//
//  PACQueryRequest.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACFile.h"
#import "PACQueryPayload.h"
#import "PACQuery.h"
#import "PACQueryResponse.h"
#import "PACQueryRequest.h"

@interface PACQueryRequest ()
/**
 Returns a boolean value
 indicating wether the
 operation is still executing.
 */
@property (readwrite, nonatomic) BOOL executingOperation;
/**
 Returns a boolean value
 indicator wether the
 operation has finished
 it's task.
 */
@property (readwrite, nonatomic) BOOL finishedOperation;
/**
 The NSURLSessionTask
 object; the request's
 networking/download task.
 */
@property (strong, readwrite, nonatomic) NSURLSessionTask *URLSessionTask;
@property (strong, readwrite, nonatomic) PACQuery *query;
@property (strong, readwrite, nonatomic) PACQueryResponse *response;
@end

@interface NSObject (JSONString)
/**
 Generate a JSON string from a
 Foundation object, supported
 types are NSArray and NSDictionary.
 */
- (NSString *)JSONString;
@end

@implementation NSObject (JSONString)
- (NSString *)JSONString {
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
    return JSONData ? [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding] : ([self isKindOfClass:[NSDictionary class]] ? @"{}" : @"[]");
}
@end

@implementation PACQueryRequest

- (NSString *)description {
    return [NSString stringWithFormat:@"[Query: %@, Timeout Interval: %lu, Response: %@]", self.query, (unsigned long)self.timeoutInterval, self.response];
}

#pragma mark - NSOperation Concurrency

- (void)start {
    if (self.isCancelled)
        return;
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    [self setExecutingOperation:YES];
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main {
    [self asynchronouslyDispatchWithCompletionHandler:^(PACQueryResponse *response) {
        if (self.isCancelled)
            return;
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        [self setResponse:response];
        [self setFinishedOperation:YES];
        [self setExecutingOperation:NO];
        [self didChangeValueForKey:@"isFinished"];
        [self didChangeValueForKey:@"isExecuting"];
    }];
}

- (void)cancel {
    [self willChangeValueForKey:@"isFinished"];
    [self setFinishedOperation:YES];
    if (self.URLSessionTask)
        [self.URLSessionTask cancel];
    [self didChangeValueForKey:@"isFinished"];
    [super cancel];
}

- (BOOL)isExecuting {
    return self.executingOperation;
}

- (BOOL)isFinished {
    return self.finishedOperation;
}

- (BOOL)isReady {
    return !!self.query;
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark - Dispatch

- (void)asynchronouslyDispatchWithCompletionHandler:(QueryRequestDispatchCompletionHandlerBlock)completionHandler {
    if (self.isCancelled)
        return;
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[APIURLBase stringByAppendingString:self.query.URI]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeoutInterval];
    [URLRequest setHTTPMethod:self.query.HTTPMethod];
    for (NSString *headerField in [self.query.headers allKeys])
        [URLRequest setValue:self.query.headers[headerField] forHTTPHeaderField:headerField];
    if ([self.query.HTTPMethod isEqualToString:@"POST"]) {
        // POST request
        if (!self.query.payload.files.count) {
            // No files required, add JSON to body
            [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            if (self.query.payload)
                [URLRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:self.query.payload.body options:kNilOptions error:nil]];
        }
        else {
            // Attach files to HTTP request; multipart/form-data query, add JSON and file to body
            NSString *boundary = [self generateMultipartBoundaryWithLength:32 andCharSet:alphanumericSet];
            [URLRequest addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
            NSMutableData *bodyData = [NSMutableData data];
            for (NSString *bodyField in [self.query.payload.body allKeys]) {
                [bodyData appendData:[[NSString stringWithFormat:@"%@--%@\r\n", [self.query.payload.body.allKeys indexOfObject:bodyField] ? @"\r\n" : @"", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", bodyField, [self.query.payload.body[bodyField] JSONString]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            for (PACFile *file in self.query.payload.files) {
                [bodyData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", file.name, file.filename] dataUsingEncoding:NSUTF8StringEncoding]];
                [bodyData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", file.HTTPContentType] dataUsingEncoding:NSUTF8StringEncoding]];
                [bodyData appendData:[NSData dataWithData:[file data]]];
            }
            [bodyData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [URLRequest setHTTPBody:bodyData];
            [URLRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)bodyData.length] forHTTPHeaderField:@"Content-Length"];
        }
        [self setURLSessionTask:[[NSURLSession sharedSession] dataTaskWithRequest:URLRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (self.isCancelled)
                return;
            if (completionHandler)
                completionHandler([PACQueryResponse responseWithError:error URLResponse:(NSHTTPURLResponse *)response andRawData:data]);
        }]];
    }
    else if ([self.query.HTTPMethod isEqualToString:@"GET"]) {
        // GET request, add parameters to URL
        NSMutableString *parameterizedURI = [[APIURLBase stringByAppendingString:[self.query.URI stringByAppendingString:@"?"]] mutableCopy];
        for (NSInteger i = 0; i < [self.query.payload.body allKeys].count; i++) {
            [parameterizedURI appendFormat:@"%@=%@%@", [self.query.payload.body allKeys][i], self.query.payload.body[[self.query.payload.body allKeys][i]], i < ([self.query.payload.body allKeys].count - 1) ? @"&" : @""];
        }
        [self setURLSessionTask:[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:parameterizedURI] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (self.isCancelled)
                return;
            if (completionHandler)
                completionHandler([PACQueryResponse responseWithError:error URLResponse:(NSHTTPURLResponse *)response andRawData:data]);
        }]];
    }
    [self.URLSessionTask resume];
}

- (NSString *)generateMultipartBoundaryWithLength:(NSInteger)length andCharSet:(NSString *)charSet {
    NSMutableString *boundary = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i <= length; i++) {
        u_int32_t r = arc4random() % [charSet length];
        unichar c = [charSet characterAtIndex:r];
        [boundary appendFormat:@"%C", c];
    }
    return boundary;
}

#pragma mark - Init

+ (PACQueryRequest *)requestWithQuery:(PACQuery *)query {
    return [[self alloc] initWithQuery:query];
}

- (id)initWithQuery:(PACQuery *)query {
    if (self = [self init]) {
        [self setQuery:query];
    }
    return self;
}

+ (PACQueryRequest *)requestWithQuery:(PACQuery *)query andTimeoutInterval:(NSUInteger)timeoutInterval {
    PACQueryRequest *request = nil;
    if (!request)
        request = [[self alloc] initWithQuery:query andTimeoutInterval:timeoutInterval];
    return request;
}

- (id)initWithQuery:(PACQuery *)query andTimeoutInterval:(NSUInteger)timeoutInterval {
    if (self = [self initWithQuery:query]) {
        [self setTimeoutInterval:timeoutInterval];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self setTimeoutInterval:60.0f];
        [self setExecutingOperation:NO];
        [self setFinishedOperation:NO];
    }
    return self;
}

@end