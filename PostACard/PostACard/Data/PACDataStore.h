//
//  PACDataStore.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@class PACUser;
@class PACModelObject;
@class PACFile;
@class PACDataStorePredicate;

@interface NSArray (Filtering)
/**
 Return a new array with
 a data store predicate
 applied.
 */
- (NSArray *)filteredArrayUsingDataStorePredicate:(PACDataStorePredicate *)predicate;
@end

/**
 The PACDataStore is an in-mem
 data storage medium, locally
 holding model data like users,
 card templates, cards, etc.
 Depending on networking cache
 policies, data can be fetched
 from here.
 */
@interface PACDataStore : NSObject

/**
 Unique collection of PACFiles.
 */
@property (strong, readonly, nonatomic) NSMutableArray *files;
/**
 Unique collection of PACUsers.
 */
@property (strong, readonly, nonatomic) NSMutableArray *users;
/**
 Unique collection of PACCardTemplates.
 */
@property (strong, readonly, nonatomic) NSMutableArray *cardTemplates;
/**
 Unique collection of PACCards.
 */
@property (strong, readonly, nonatomic) NSMutableArray *cards;

/**
 Returns the shared data store.
 */
+ (PACDataStore *)sharedStore;

/**
 Login to a user in the data
 store.
 */
- (void)loginUser:(PACUser *)user;
/**
 Write a model object to the
 data store.
 */
- (void)saveModelObject:(PACModelObject *)modelObject;
/**
 Write a file to the data store.
 */
- (void)saveFile:(PACFile *)file;

/**
 Returns the logged-in user.
 */
- (PACUser *)loggedInUser;
/**
 Fetch model objects from the
 data store with a predicate.
 */
- (NSArray *)fetchModelObjectsWithDataStorePredicate:(PACDataStorePredicate *)predicate;
/**
 Fetch a model object from the
 data store with an associated
 ID.
 */
- (PACModelObject *)fetchModelObjectWithID:(NSString *)ID;

/**
 Clear the data store of all
 it's data.
 */
- (void)clear;
/**
 Logout the logged-in user in
 the data store.
 */
- (void)logout;
/**
 Delete a model object from the
 data store.
 */
- (BOOL)deleteModelObject:(PACModelObject *)modelObject;
/**
 Delete the file associated with
 a filename from the data store.
 */
- (BOOL)deleteFileWithFilename:(NSString *)filename;

@end
