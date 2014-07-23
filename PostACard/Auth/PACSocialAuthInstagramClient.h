//
//  PACSocialAuthInstagramClient.h
//  PostACard
//
//  Created by Rohan Kapur on 20/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACSocialAuthClient.h"

@interface PACSocialAuthInstagramClient : PACSocialAuthClient

- (void)deriveBasicUserFromInstagramUsername:(NSString *)username withCompletionHandler:(UserDownloadCompletionHandler)completionHandler;

@end
