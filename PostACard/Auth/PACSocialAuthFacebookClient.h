//
//  PACSocialAuthFacebookClient.h
//  PostACard
//
//  Created by Rohan Kapur on 20/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "FBLoginView.h"
#import "PACSocialAuthClient.h"

@protocol PACSocialAuthFacebookClientDelegate <NSObject>
- (void)successfullyDerivedUser:(PACUser *)user;
- (void)failedToDeriveUserWithError:(NSError *)error;
@end

@interface PACSocialAuthFacebookClient : PACSocialAuthClient <FBLoginViewDelegate>

/**
 The client's delegate.
 */
@property (strong, readwrite, nonatomic) id<PACSocialAuthFacebookClientDelegate> delegate;

/**
 Derive a basic PACUser from a
 Facebook account using the Social
 Framework.
 */
- (void)deriveBasicUserFromFacebookSocialFrameworkWithCompletionHandler:(UserDownloadCompletionHandler)completionHandler;

/**
 The client's required auth
 permissions.
 */
- (NSArray *)requiredPermissions;

@end
