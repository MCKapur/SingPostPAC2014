//
//  PACSocialAuthTwitterClient.h
//  PostACard
//
//  Created by Rohan Kapur on 20/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACSocialAuthClient.h"

@interface PACSocialAuthTwitterClient : PACSocialAuthClient

/**
 Derive a basic PACUser from a Twitter
 account with the account's screen name.
 */
- (void)deriveBasicUserFromTwitterUsername:(NSString *)username withCompletionHandler:(UserDownloadCompletionHandler)completionHandler;

/**
 Derive a basic PACUser from a Twitter
 account using the Social Framework.
 */
- (void)deriveBasicUserFromSocialFrameworkWithCompletionHandler:(UserDownloadCompletionHandler)completionHandler;

@end
