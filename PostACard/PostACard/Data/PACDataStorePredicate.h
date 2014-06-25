//
//  PACDataStorePredicate.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@class PACQueryPayload;

/**
 A PACDataStorePredicate is 
 used to query and filter 
 Foundation objects in the
 local data store.
 */
@interface PACDataStorePredicate : NSObject

/**
 The predicate's sort descriptor,
 containing information on how to
 sort the fetched objects.
 */
@property (strong, readwrite, nonatomic) NSSortDescriptor *sortDescriptor;

/**
 The maximum number of objects
 to fetch.
 */
@property (readwrite, nonatomic) NSUInteger resultsLimit;

/**
 The predicate's model object
 target class.
 */
@property (strong, readonly, nonatomic) Class modelClass;

/**
 An NSPredicate representation of
 the predicate format.
 */
- (NSPredicate *)NSPredicateRepresentation;

/**
 Returns a newly initialized
 PACDataStorePredicate with
 a query payload and model
 class.
 */
+ (PACDataStorePredicate *)predicateWithQueryPayload:(PACQueryPayload *)queryPayload andModelClass:(Class)modelClass;

/**
 Returns a newly initialized
 PACDataStorePredicate with
 a query payload and model
 class.
 */
- (id)initWithQueryPayload:(PACQueryPayload *)queryPayload andModelClass:(Class)modelClass;

@end
