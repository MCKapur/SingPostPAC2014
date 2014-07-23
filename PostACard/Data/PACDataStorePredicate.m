//
//  PACDataStorePredicate.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACQueryPayload.h"
#import "PACDataStorePredicate.h"

@interface PACDataStorePredicate ()
/**
 The predicate format.
 */
@property (strong, readwrite, nonatomic) NSString *predicateFormat;
@property (strong, readwrite, nonatomic) NSMutableArray *predicateFormatArguments;
@property (strong, readwrite, nonatomic) Class modelClass;
@end

@implementation PACDataStorePredicate

+ (PACDataStorePredicate *)predicateWithQueryPayload:(PACQueryPayload *)queryPayload andModelClass:(Class)modelClass {
    return [[self alloc] initWithQueryPayload:queryPayload andModelClass:modelClass];
}

- (id)initWithQueryPayload:(PACQueryPayload *)queryPayload andModelClass:(Class)modelClass {
    // Reliant on backend API.
    return nil;
}

@end
