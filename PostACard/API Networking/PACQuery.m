//
//  PACQuery.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACQueryPayload.h"
#import "PACQuery.h"

@interface PACQuery ()
@property (strong, readwrite, nonatomic) NSString *URI;
@property (strong, readwrite, nonatomic) NSString *HTTPMethod;
@property (strong, readwrite, nonatomic) PACQueryPayload *payload;
@end

@implementation PACQuery

- (NSString *)description {
    return [NSString stringWithFormat:@"[HTTP Method: %@, URI: %@, Headers: %@, Payload: %@]", self.HTTPMethod, self.URI, self.headers, self.payload];
}

#pragma mark - Init

+ (PACQuery *)queryWithAPIEndpointIdentifier:(NSString *)APIEndpointIdentifier payload:(PACQueryPayload *)payload andHeaders:(NSDictionary *)headers {
    return [[self alloc] initWithAPIEndpointIdentifier:APIEndpointIdentifier payload:payload andHeaders:headers];
}

- (id)initWithAPIEndpointIdentifier:(NSString *)APIEndpointIdentifier payload:(PACQueryPayload *)payload andHeaders:(NSDictionary *)headers {
    if (self = [self init]) {
        [self setURI:[self expandAPIEndpointIdentifier:APIEndpointIdentifier][@"URI"]];
        [self setPayload:payload];
        [self setHTTPMethod:[self expandAPIEndpointIdentifier:APIEndpointIdentifier][@"HTTPMethod"]];
        [self setHeaders:[headers?headers:@{} mutableCopy]];
    }
    return self;
}

- (id)init {
    return [super init];
}

- (NSDictionary *)expandAPIEndpointIdentifier:(NSString *)endpointIdentifier {
    // With the format "HTTP_METHOD->ENDPOINT_URI"
    return @{@"HTTPMethod": [endpointIdentifier componentsSeparatedByString:@"->"][0], @"URI": [endpointIdentifier componentsSeparatedByString:@"->"][1]};
}

@end