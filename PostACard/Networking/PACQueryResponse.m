//
//  PACQueryResponse.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACQueryResponse.h"

@interface PACQueryResponse ()
@property (strong, readwrite, nonatomic) NSError *error;
@property (strong, readwrite, nonatomic) NSHTTPURLResponse *URLResponse;
@property (strong, readwrite, nonatomic) NSData *rawData;
@property (strong, readwrite, nonatomic) id parsedData;
@end

@implementation PACQueryResponse

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld: %@", (long)self.URLResponse.statusCode, self.error ? self.error.localizedDescription : @"OK"];
}

#pragma mark - Data

- (void)setRawData:(NSData *)rawData {
    _rawData = rawData;
    [self setParsedData:[self parseRawData:_rawData]];
}

- (id)parseRawData:(NSData *)rawData {
    if (!self.URLResponse || !rawData)
        return nil;
    id parsedData = nil;
    if ([[self.URLResponse allHeaderFields][@"Content-Type"] isEqualToString:@"application/json"]) {
        NSDictionary *tempParsedData = [NSJSONSerialization JSONObjectWithData:rawData options:/* Deep Mutable Copy */NSJSONReadingMutableContainers error:nil];
        parsedData = [NSMutableDictionary dictionary];
        for (NSString *key in [tempParsedData allKeys])
            if (![tempParsedData[key] isEqual:[NSNull null]])
                parsedData[key] = tempParsedData[key];
    }
    else if ([[self.URLResponse allHeaderFields][@"Content-Type"] isEqualToString:@"image/jpeg"] || [[self.URLResponse allHeaderFields][@"Content-Type"] isEqualToString:@"image/png"]) {
        parsedData = [UIImage imageWithData:rawData];
    }
    return parsedData;
}

#pragma mark - Init

+ (PACQueryResponse *)responseWithError:(NSError *)error URLResponse:(NSHTTPURLResponse *)URLResponse andRawData:(NSData *)rawData {
    return [[PACQueryResponse alloc] initWithError:error URLResponse:URLResponse andRawData:rawData];
}

- (id)initWithError:(NSError *)error URLResponse:(NSHTTPURLResponse *)URLResponse andRawData:(NSData *)rawData {
    if (self = [self init]) {
        [self setURLResponse:URLResponse];
        [self setRawData:rawData];
        [self setError:error?error:[NSError errorWithDomain:@"OperationError" code:self.URLResponse.statusCode userInfo:@{NSLocalizedDescriptionKey: self.parsedData[@"error"]?self.parsedData[@"error"]:@"Unknown error."}]];
    }
    return self;
}

- (id)init {
    return [super init];
}

@end