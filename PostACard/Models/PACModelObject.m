//
//  PACModelObject.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@implementation NSString (StringToDate)
- (NSDate *)NSDateFromISOString {
    NSDateFormatter *ISODateFormatter = [[NSDateFormatter alloc] init];
    [ISODateFormatter setDateFormat:ISODateFormat];
    return [ISODateFormatter dateFromString:self];
}
@end

@implementation NSDate (DateToString)
- (NSString *)ISOStringFromNSDate {
    NSDateFormatter *ISODateFormatter = [[NSDateFormatter alloc] init];
    [ISODateFormatter setDateFormat:ISODateFormat];
    return [ISODateFormatter stringFromDate:self];
}
@end

#import "PACModelObject.h"

@interface PACModelObject ()
@property (strong, readwrite, nonatomic) NSString *ID;
@end

@implementation PACModelObject

#pragma mark - Download

- (void)downloadWithCachePolicy:(PACQueryRequestCachePolicy)cachePolicy completionHandler:(DownloadCompletionHandlerBlock)completionHandler {
}

- (BOOL)isDownloaded {
    return !!self.ID;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.ID forKey:@"ID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        [self setID:[aDecoder decodeObjectForKey:@"ID"]];
    }
    return self;
}

#pragma mark - Init

- (id)initWithJSON:(NSDictionary *)JSON {
    return self = [self initWithID:JSON[@"_id"]];
}

+ (instancetype)objectWithID:(NSString *)ID {
    return [[self alloc] initWithID:ID];
}

- (instancetype)initWithID:(NSString *)ID {
    if (self = [self init])
        [self setID:ID];
    return self;
}

- (id)init {
    return [super init];
}

@end
