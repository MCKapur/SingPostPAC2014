//
//  PACQueryPayload.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

/**
 A PACQueryPayload stores query
 request data like the body
 and file(s) data.
 */
@interface PACQueryPayload : NSObject

/**
 The query's files used
 in the body of multipart
 requests.
 */
@property (strong, readwrite, nonatomic) NSMutableArray *files;

/**
 The query properties sent
 as the request body.
 */
@property (strong, readwrite, nonatomic) NSMutableDictionary *body;

/**
 Returns a newly initialized
 PACQueryPayload object.
 */
+ (PACQueryPayload *)payload;

@end
