//
//  PACSocialAuthClient.h
//  PostACard
//
//  Created by Rohan Kapur on 20/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@class PACUser;

typedef void (^PhotoFeedDownloadCompletionHandler)(NSError *error, NSArray *photos);
typedef void (^UserDownloadCompletionHandler)(NSError *error, PACUser *derivedUser);

@interface PACSocialAuthClient : NSObject

/**
 The shared client.
 */
+ (instancetype)sharedClient;

/**
 Retrieve a feed of user's photos.
 */
- (void)retrievePhotosWithCompletionHandler:(PhotoFeedDownloadCompletionHandler)completionHandler;

@end
