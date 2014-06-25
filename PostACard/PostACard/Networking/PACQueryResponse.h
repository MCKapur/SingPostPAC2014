//
//  PACQueryResponse.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

/**
 A PACQueryResponse stores
 information returned from a
 dispatched query request; eg.
 the HTTP URL connection response,
 the raw/parsed data and any
 errors.
 */
@interface PACQueryResponse : NSObject

/**
 The response's returned error.
 */
@property (strong, readonly, nonatomic) NSError *error;

/**
 The response's HTTP response.
 */
@property (strong, readonly, nonatomic) NSHTTPURLResponse *URLResponse;

/**
 The response's returned raw data.
 */
@property (strong, readonly, nonatomic) NSData *rawData;

/**
 The response's parsed raw data.
 */
@property (strong, readonly, nonatomic) id parsedData;

/**
 Returns a newly initialized
 PACQueryResponse object with
 an error, URL response and data.
 */
+ (PACQueryResponse *)responseWithError:(NSError *)error URLResponse:(NSHTTPURLResponse *)URLResponse andRawData:(NSData *)data;

/**
 Returns a newly initialized
 PACQueryResponse object with
 an error, URL response and data.
 */
- (id)initWithError:(NSError *)error URLResponse:(NSHTTPURLResponse *)URLResponse andRawData:(NSData *)data;

@end
