//
//  PACSocialAuthTwitterClient.m
//  PostACard
//
//  Created by Rohan Kapur on 20/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACUser.h"
#import "STTwitterAPI.h"
#import "PACSocialAuthTwitterClient.h"

#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation PACSocialAuthTwitterClient

- (void)deriveBasicUserFromTwitterUsername:(NSString *)username withCompletionHandler:(UserDownloadCompletionHandler)completionHandler {
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TwitterOAuthConsumerKey consumerSecret:TwitterOAuthConsumerSecret];
    [twitter getUsersShowForUserID:nil orScreenName:username includeEntities:nil successBlock:^(NSDictionary *user) {
        PACUser *derivedUser = [PACUser objectWithJSON:@{@"loginProvider": @(PACLoginProviderTypeTwitter), @"name": user[@"name"], @"location": user[@"location"], @"socialID": user[@"id"]}];
        completionHandler(nil, derivedUser);
    } errorBlock:^(NSError *error) {
        completionHandler(error, nil);
    }];
}

- (void)deriveBasicUserFromSocialFrameworkWithCompletionHandler:(UserDownloadCompletionHandler)completionHandler {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            if (accounts.count) {
                ACAccount *account = accounts[0];
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:@{@"screen_name": account.username}];
                request.account = account;
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if ((!error && urlResponse.statusCode == 200) && responseData) {
                        NSError *error = nil;
                        NSDictionary *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                        if (!error && TWData) {
                            PACUser *user = [PACUser objectWithJSON:@{@"loginProvider": @(PACLoginProviderTypeTwitter), @"name": TWData[@"name"], @"location": TWData[@"location"], @"socialID": TWData[@"id"]}];
                            completionHandler(nil, user);
                        }
                        else {
                            completionHandler(error, nil);
                        }
                    }
                    else {
                        completionHandler(error, nil);
                    }
                }];
            }
            else {
                completionHandler([NSError errorWithDomain:@"TwitterAuthError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"No Twitter accounts found."}], nil);
            }
        }
        else {
            completionHandler([NSError errorWithDomain:@"TwitterAuthError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"Twitter account access not granted."}], nil);
        }
    }];
}

@end
