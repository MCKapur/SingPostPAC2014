//
//  PACQuery.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@class PACQueryPayload;

/**
 A PACQuery object stores query info
 like the payload, endpoint URI, REST
 method and request headers.
 */
@interface PACQuery : NSObject

/**
 The API endpoint URI, the route
 proceeding the base URL.
 */
@property (strong, readonly, nonatomic) NSString *URI;

/**
 The HTTP REST method, eg. POST,
 GET, PUT, OPTIONS, DELETE.
 */
@property (strong, readonly, nonatomic) NSString *HTTPMethod;

/**
 The request header fields.
 */
@property (strong, readwrite, nonatomic) NSMutableDictionary *headers;

/**
 The query's payload object.
 */
@property (strong, readonly, nonatomic) PACQueryPayload *payload;

/**
 Returns a newly initialized
 PACQuery object with an API 
 endpoint identifier, payload
 and headers.
 */
+ (PACQuery *)queryWithAPIEndpointIdentifier:(NSString *)APIEndpointIdentifier payload:(PACQueryPayload *)payload andHeaders:(NSDictionary *)headers;

/**
 Returns a newly initialized
 PACQuery object with an API
 endpoint identifier, payload
 and headers.
 */
- (id)initWithAPIEndpointIdentifier:(NSString *)APIEndpointIdentifier payload:(PACQueryPayload *)payload andHeaders:(NSDictionary *)headers;

@end
