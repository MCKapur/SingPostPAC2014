//
//  PACDataStore.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACCardTemplate.h"
#import "PACCard.h"
#import "PACFile.h"
#import "PACUser.h"
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
 Add the file object if it
 does not already exist in
 the in-mem cache, if it does
 then replace it. Equality
 based on filename matching.
 */
- (void)addOrModifyFile:(PACFile *)file;
/**
 Remove the file object
 if it exists in the
 in-mem cache, equality
 based on filename matching.
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
    if (index != NSNotFound) {
        [((PACFile *)self[index]) purge];
        [self removeObjectAtIndex:index];
    }
    return (index != NSNotFound);
}
@end

@implementation NSArray (Filtering)
- (NSArray *)filteredArrayUsingDataStorePredicate:(PACDataStorePredicate *)predicate {
    NSArray *retVal = [self filteredArrayUsingPredicate:[predicate NSPredicateRepresentation]];
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
@property (strong, readwrite, nonatomic) NSString *loggedInID;
@property (strong, readwrite, nonatomic) PACUser *loggedInUser;
@end

@implementation PACDataStore

- (NSArray *)dynamicCategories {
    return @[@"New Years", @"Christmas", @"Chinese New Year", @"Easter"];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dynamicCategories forKey:@"dynamicCategories"];
    [aCoder encodeObject:self.files forKey:@"files"];
    [aCoder encodeObject:self.users forKey:@"users"];
    [aCoder encodeObject:self.cardTemplates forKey:@"cardTemplates"];
    [aCoder encodeObject:self.cards forKey:@"cards"];
    [aCoder encodeObject:self.loggedInID forKey:@"loggedInID"];
    [aCoder encodeObject:self.loggedInUser forKey:@"loggedInUser"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        [self setDynamicCategories:[aDecoder decodeObjectForKey:@"dynamicCategories"]];
        [self setFiles:[aDecoder decodeObjectForKey:@"files"]];
        [self setUsers:[aDecoder decodeObjectForKey:@"users"]];
        [self setCardTemplates:[aDecoder decodeObjectForKey:@"cardTemplates"]];
        [self setCards:[aDecoder decodeObjectForKey:@"cards"]];
        [self setLoggedInID:[aDecoder decodeObjectForKey:@"loggedInID"]];
        [self setLoggedInUser:[aDecoder decodeObjectForKey:@"loggedInUser"]];
    }
    return self;
}

#pragma mark - Persistance

- (void)setDumpPath:(NSString *)dumpPath {
    [[NSUserDefaults standardUserDefaults] setObject:dumpPath forKey:@"CRDataStore_Dump_Path"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)dumpPath {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CRDataStore_Dump_Path"];
}

- (void)persist {
    PACFile *dataStoreFile = [PACFile fileWithFileName:@"CRDataStore_Dump" andData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    [self setDumpPath:[dataStoreFile filePath]];
}

- (void)loadFromPersistedDump {
    NSData *persistedData = [NSData dataWithContentsOfFile:[self dumpPath]];
    if (!persistedData)
        return;
    PACDataStore *persistedDataStore = [NSKeyedUnarchiver unarchiveObjectWithData:persistedData];
    if (!persistedDataStore)
        return;
    [self setFiles:persistedDataStore.files];
    [self setUsers:persistedDataStore.users];
    [self setCardTemplates:persistedDataStore.cardTemplates];
    [self setCards:persistedDataStore.cards];
    [self setDynamicCategories:persistedDataStore.dynamicCategories];
    [self setLoggedInUser:persistedDataStore.loggedInUser];
    [self setLoggedInID:persistedDataStore.loggedInID];
}

#pragma mark - Read

- (BOOL)isLoggedIn {
    return !!_loggedInID;
}

- (PACUser *)loggedInUser {
    if (![self isLoggedIn])
        return nil;
    return _loggedInUser ? _loggedInUser : [PACUser objectWithID:self.loggedInID];
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

- (PACFile *)fetchFileWithFilename:(NSString *)filename {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filename == %@", filename];
    NSArray *filtered = [self.files filteredArrayUsingPredicate:predicate];
    return filtered.count ? filtered[0] : nil;
}

#pragma mark - Write

- (void)loginUser:(PACUser *)user {
    [self setLoggedInID:user.ID];
    [self setLoggedInUser:user];
}

- (void)saveModelObject:(PACModelObject *)modelObject {
    if ([modelObject isKindOfClass:[PACUser class]])
        [((NSMutableArray *)self.users) addOrModifyModelObject:modelObject];
    else if ([modelObject isKindOfClass:[PACCardTemplate class]])
        [((NSMutableArray *)self.cardTemplates) addOrModifyModelObject:modelObject];
    else if ([modelObject isKindOfClass:[PACCard class]])
        [((NSMutableArray *)self.cards) addOrModifyModelObject:modelObject];
}

- (void)saveFile:(PACFile *)file {
    [(NSMutableArray *)self.files addOrModifyFile:file];
}

#pragma mark - Delete

- (BOOL)deleteFileWithFilename:(NSString *)filename {
    return [(NSMutableArray *)self.files removeFileWithFilename:filename];
}

- (void)logout {
    [self setLoggedInUser:nil];
    [self setLoggedInID:nil];
    [[PACDataStore sharedStore] clear];
}

- (BOOL)deleteModelObject:(PACModelObject *)modelObject {
    BOOL deleted = NO;
    if (!deleted) deleted = [((NSMutableArray *)self.users) removeModelObject:modelObject];
    if (!deleted) deleted = [((NSMutableArray *)self.cardTemplates) removeModelObject:modelObject];
    if (!deleted) deleted = [((NSMutableArray *)self.cards) removeModelObject:modelObject];
    return deleted;
}

- (void)clear {
    [self setFiles:[NSMutableArray array]];
    [self setUsers:[NSMutableArray array]];
    [self setCardTemplates:[NSMutableArray array]];
    [self setCards:[NSMutableArray array]];
    [self setDynamicCategories:[NSArray array]];
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
        [self setDynamicCategories:[NSArray array]];
    }
    return self;
}

@end
