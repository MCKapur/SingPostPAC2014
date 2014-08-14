//
//  PACSocialAuthFacebookClient.h
//  PostACard
//
//  Created by Rohan Kapur on 20/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACSocialAuthClient.h"

typedef void (^PACLoginCompletionHandlerBlock)(NSError *error, PACUser *user);
typedef void (^PACLogoutCompletionHandlerBlock)(NSError *error);
typedef void (^PACReviveCachedSessionCompletionHandlerBlock)(NSError *error);
typedef void (^PACHandleColdStartCompletionHandlerBlock)(NSError *error);
typedef void (^DownloadProfilePictureCompletionHandler)(NSError *error, UIImage *profilePicture);

@interface PACSocialAuthFacebookClient : PACSocialAuthClient

/**
 The client's required auth
 read permissions.
 */
- (NSArray *)readPermissions;

/**
 Attempt a Facebook login.
 */
- (void)loginWithCompletionHandler:(PACLoginCompletionHandlerBlock)completionHandler;
/**
 Logout from Facebook.
 */
- (void)logoutWithCompletionHandler:(PACLogoutCompletionHandlerBlock)completionHandler;

/**
 Revive the cached session, if any.
 */
- (void)reviveCachedSessionWithCompletionHandler:(PACReviveCachedSessionCompletionHandlerBlock)completionHandler;

/**
 Handle a cold start, a scenario where
 the app is terminated during the Facebook
 login process (switch to Safari).
 */
- (void)handleColdStartWithCompletionHandler:(PACHandleColdStartCompletionHandlerBlock)completionHandler;

@end
