//
//  PACQueryPayload.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACQueryPayload.h"

@implementation PACQueryPayload

- (NSString *)description {
    return [NSString stringWithFormat:@"[Body: %@, Files: %@]", self.body, self.files];
}

#pragma mark - Init

+ (PACQueryPayload *)payload {
    return [[self alloc] init];
}

- (id)init {
    if (self = [super init] ) {
        [self setFiles:[NSMutableArray array]];
        [self setBody:[NSMutableDictionary dictionary]];
    }
    return self;
}

@end
