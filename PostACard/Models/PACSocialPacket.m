//
//  PACSocialPacket.m
//  PostACard
//
//  Created by Rohan Kapur on 22/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACSocialPacket.h"

@interface PACSocialPacket ()
@property (strong, readwrite, nonatomic) NSString *socialID;
@property (strong, readwrite, nonatomic) NSString *accessToken;
@end

@implementation PACSocialPacket

- (NSString *)description {
    return [NSString stringWithFormat:@"Social ID: %@, Access Token: %@", self.socialID, self.accessToken];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.socialID forKey:@"socialID"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        [self setSocialID:[aDecoder decodeObjectForKey:@"socialID"]];
        [self setAccessToken:[aDecoder decodeObjectForKey:@"accessToken"]];
    }
    return self;
}

#pragma mark - Init

+ (PACSocialPacket *)socialPacketWithID:(NSString *)socialID andAccessToken:(NSString *)accessToken {
    return [[self alloc] initWithID:socialID andAccessToken:accessToken];
}

- (id)initWithID:(NSString *)socialID andAccessToken:(NSString *)accessToken {
    if (self = [self init]) {
        [self setSocialID:socialID];
        [self setAccessToken:accessToken];
    }
    return self;
}

- (id)init {
    return [super init];
}

@end
