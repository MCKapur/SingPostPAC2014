//
//  PACModelObject.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

typedef void (^DownloadCompletionHandlerBlock)(NSError *error);

/**
 A PACModelObject is the base
 framework for unique PAC model
 objects.
 */
@interface PACModelObject : NSObject

/**
 A unique ID.
 */
@property (strong, readonly, nonatomic) NSString *ID;

/**
 If the object has fully down-
 loaded and satisfied it's
 properties.
 */
@property (readonly, nonatomic) BOOL isDownloaded;

/**
 Download the model object
 based on an ID query.
 */
- (void)downloadWithCompletionHandler:(DownloadCompletionHandlerBlock)completionHandler;

/**
 Call this method when a model
 object's 'isDownloaded' property
 is set to true.
 */
- (void)downloaded;

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

@end
