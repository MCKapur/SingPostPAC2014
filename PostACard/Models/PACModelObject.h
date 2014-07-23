//
//  PACModelObject.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@interface NSString (StringToDate)
/**
 Convert an ISO-8601 string returned
 to an NSDate object.
 */
- (NSDate *)NSDateFromISOString;
@end

@interface NSDate (DateToString)
/**
 Convert an NSDate into an ISO-8601
 date formatted string.
 */
- (NSString *)ISOStringFromNSDate;
@end

/**
 A PACModelObject is the base
 framework for uniqbue PAC model
 objects.
 */
@interface PACModelObject : NSObject <NSCoding>

/**
 A unique ID.
 */
@property (strong, readonly, nonatomic) NSString *ID;

/**
 Only initialize the object
 with an ID; not downloaded yet.
 */
+ (instancetype)objectWithID:(NSString *)ID;

/**
 Only initialize the object
 with an ID; not downloaded yet.
 */
- (instancetype)initWithID:(NSString *)ID;

/**
 Returns a newly initialized
 model object with properties
 stashed in a parsed JSON
 dictionary.
 */
+ (instancetype)objectWithJSON:(NSDictionary *)JSON;

/**
 Returns a newly initialized
 model object with properties
 stashed in a parsed JSON
 dictionary.
 */
- (instancetype)initWithJSON:(NSDictionary *)JSON;

typedef void (^DownloadCompletionHandlerBlock)(NSError *error, PACModelObject *modelObject);
/**
 Download the model object and initialize
 it's properties providing a cache policy.
 */
- (void)downloadWithCachePolicy:(PACQueryRequestCachePolicy)cachePolicy completionHandler:(DownloadCompletionHandlerBlock)completionHandler;

/**
 Returns YES the object has fully
 downloaded and satisfied it's properties.
 */
- (BOOL)isDownloaded;

@end
