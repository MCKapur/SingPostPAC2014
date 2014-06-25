//
//  PACDataStore.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACCardTemplate.h"
#import "PACCard.h"
#import "PACUser.h"
#import "PACFile.h"
#import "PACQueryPayload.h"
#import "PACQueryPayload+ModularComposer.h"
#import "PACDataStorePredicate.h"
#import "PACDataStore.h"

@interface NSMutableArray (UniqueSaving)
/**
 Add the model object if it
 does not already exist in
 the in-mem cache, if it does
 then replace it. Equality based
 on ID matches.
 */
- (void)addOrModifyModelObject:(PACModelObject *)modelObject;
/**
 Remove the model object if it
 exists in the in-mem cache,
 equality based on ID matches.
 */
- (BOOL)removeModelObject:(PACModelObject *)modelObject;
/**
 Add the file object if it does
 not already exist in the in-mem
 cache, if it does then replace it.
 Equality based on filename matches.
 */
- (void)addOrModifyFile:(PACFile *)file;
/**
 Remove the file object if it
 exists in the in-mem cache,
 equality based on filename matches.
 */
- (BOOL)removeFileWithFilename:(NSString *)filename;
@end

@implementation NSMutableArray (UniqueSaving)
- (void)addOrModifyModelObject:(PACModelObject *)modelObject {
    if (![modelObject isKindOfClass:[PACModelObject class]])
        return;
    NSInteger index = NSNotFound;
    for (NSInteger i = 0; i < self.count; i++) {
        if ([((PACModelObject *)self[i]).ID isEqualToString:modelObject.ID])
            index = i;
    }
    if (index == NSNotFound)
        [self addObject:modelObject];
    else
        [self replaceObjectAtIndex:index withObject:modelObject];
}
- (void)addOrModifyFile:(PACFile *)file {
    if (![file isKindOfClass:[PACFile class]])
        return;
    NSInteger index = NSNotFound;
    for (NSInteger i = 0; i < self.count; i++) {
        if ([((PACFile *)self[i]).filename isEqualToString:file.filename])
            index = i;
    }
    if (index == NSNotFound)
        [self addObject:file];
    else
        [self replaceObjectAtIndex:index withObject:file];
    
}
- (BOOL)removeModelObject:(PACModelObject *)modelObject {
    if (![modelObject isKindOfClass:[PACModelObject class]])
        return NO;
    NSInteger index = NSNotFound;
    for (NSInteger i = 0; i < self.count; i++) {
        if ([((PACModelObject *)self[i]).ID isEqualToString:modelObject.ID])
            index = i;
    }
    if (index != NSNotFound)
        [self removeObjectAtIndex:index];
    return (index != NSNotFound);
}
- (BOOL)removeFileWithFilename:(NSString *)filename {
    NSInteger index = NSNotFound;
    for (NSInteger i = 0; i < self.count; i++) {
        if ([((PACFile *)self[i]).filename isEqualToString:filename])
            index = i;
    }
    if (index != NSNotFound)
        [self removeObjectAtIndex:index];
    return (index != NSNotFound);
}
@end

@implementation NSArray (Filtering)
- (NSArray *)filteredArrayUsingDataStorePredicate:(PACDataStorePredicate *)predicate {
    NSArray *retVal = [self filteredArrayUsingPredicate:predicate];
    if (predicate.sortDescriptor)
        retVal = [retVal sortedArrayUsingDescriptors:@[predicate.sortDescriptor]];
    if (predicate.resultsLimit)
        retVal = [retVal subarrayWithRange:NSMakeRange(0, predicate.resultsLimit)];
    return retVal;
}
@end

@interface PACDataStore ()
@property (strong, readwrite, nonatomic) NSMutableArray *files;
@property (strong, readwrite, nonatomic) NSMutableArray *users;
@property (strong, readwrite, nonatomic) NSMutableArray *cardTemplates;
@property (strong, readwrite, nonatomic) NSMutableArray *cards;
@end

@implementation PACDataStore

#pragma mark - Read

- (PACUser *)loggedInUser {
    return (PACUser *)[self fetchModelObjectWithID:[[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInUserID"]];
}

- (NSArray *)fetchModelObjectsWithDataStorePredicate:(PACDataStorePredicate *)predicate {
    NSArray *modelObjects = nil;
    if (predicate.modelClass == [PACUser class])
        modelObjects = self.users;
    else if (predicate.modelClass == [PACCard class])
        modelObjects = self.cards;
    else if (predicate.modelClass == [PACCardTemplate class])
        modelObjects = self.cardTemplates;
    return [modelObjects filteredArrayUsingDataStorePredicate:predicate];
}

- (PACModelObject *)fetchModelObjectWithID:(NSString *)ID {
    PACQueryPayload *payload = [PACQueryPayload payload];
    // Search user ID once backend API is in, along the lines
    // of:
    //  [payload addSearchUserIds:@[ID]];
    //  [payload addSearchCardTemplateIds:@[ID]];
    //  [payload addSearchCardIds:@[ID]];
    NSCompoundPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[[PACDataStorePredicate predicateWithQueryPayload:payload andModelClass:[PACUser class]], [PACDataStorePredicate predicateWithQueryPayload:payload andModelClass:[PACCardTemplate class]], [PACDataStorePredicate predicateWithQueryPayload:payload andModelClass:[PACCard class]]]];
    NSArray *filtered = [[self.users arrayByAddingObjectsFromArray:[self.cardTemplates arrayByAddingObjectsFromArray:self.cards]] filteredArrayUsingPredicate:predicate];
    return filtered.count ? filtered[0] : nil;
}

#pragma mark - Write

- (void)loginUser:(PACUser *)user {
    [[NSUserDefaults standardUserDefaults] setObject:user.ID forKey:@"loggedInUserID"];
}

- (void)saveFile:(PACFile *)file {
    [self.files addOrModifyFile:file];
}

- (void)saveModelObject:(PACModelObject *)modelObject {
    if ([modelObject isKindOfClass:[PACUser class]])
        [self.users addOrModifyModelObject:modelObject];
    else if ([modelObject isKindOfClass:[PACCardTemplate class]])
        [self.cardTemplates addOrModifyModelObject:modelObject];
    else if ([modelObject isKindOfClass:[PACCard class]])
        [self.cards addOrModifyModelObject:modelObject];
}

#pragma mark - Delete

- (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggedInUserID"];
}

- (BOOL)deleteModelObject:(PACModelObject *)modelObject {
    BOOL deleted = NO;
    if (!deleted) deleted = [self.users removeModelObject:modelObject];
    if (!deleted) deleted = [self.cardTemplates removeModelObject:modelObject];
    if (!deleted) deleted = [self.cards removeModelObject:modelObject];
    return deleted;
}

- (BOOL)deleteFileWithFilename:(NSString *)filename {
    return [self.files removeFileWithFilename:filename];
}

- (void)clear {
    [self logout];
    for (PACFile *file in self.files)
        [self deleteFileWithFilename:file.filename];
    [self setFiles:[NSMutableArray array]];
    [self setUsers:[NSMutableArray array]];
    [self setCardTemplates:[NSMutableArray array]];
    [self setCards:[NSMutableArray array]];
}

#pragma mark - Init

+ (PACDataStore *)sharedStore {
    static PACDataStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    return sharedStore;
}

- (id)init {
    if (self = [super init]) {
        [self setFiles:[NSMutableArray array]];
        [self setUsers:[NSMutableArray array]];
        [self setCardTemplates:[NSMutableArray array]];
        [self setCards:[NSMutableArray array]];
    }
    return self;
}

@end
