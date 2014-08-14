//
//  PACSocialPacket.h
//  PostACard
//
//  Created by Rohan Kapur on 22/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACModelObject.h"

@interface PACSocialPacket : NSObject <NSCoding>

/**
 The access token.
 */
@property (strong, readonly, nonatomic) NSString *accessToken;

/**
 The social ID.
 */
@property (strong, readonly, nonatomic) NSString *socialID;

/**
 Returns a newly initialized PACSocialPacket
 with an access token and social ID.
 */
+ (PACSocialPacket *)socialPacketWithID:(NSString *)socialID andAccessToken:(NSString *)accessToken;

/**
 Returns a newly initialized PACSocialPacket
 with an access token and social ID.
 */
- (id)initWithID:(NSString *)socialID andAccessToken:(NSString *)accessToken;

@end
