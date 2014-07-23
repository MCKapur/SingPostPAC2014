//
//  PACSocialAuthFacebookClient.m
//  PostACard
//
//  Created by Rohan Kapur on 20/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACUser.h"
#import "PACSocialAuthFacebookClient.h"

#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation PACSocialAuthFacebookClient

- (void)deriveBasicUserFromFacebookSocialFrameworkWithCompletionHandler:(UserDownloadCompletionHandler)completionHandler {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            if (accounts.count) {
                ACAccount *account = accounts[0];
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://graph.facebook.com/me"] parameters:nil];
                request.account = account;
                [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
                    if ((!error && response.statusCode == 200) && data) {
                        NSError *error;
                        NSDictionary *FBData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                        if (!error && FBData) {
                            PACUser *derivedUser = [PACUser objectWithJSON:@{@"loginProvider": @(PACLoginProviderTypeFacebook), @"name": FBData[@"name"], @"email": FBData[@"email"], @"loginId": FBData[@"email"], @"location": FBData[@"location"][@"name"], @"socialID": FBData[@"id"]}];
                            completionHandler(nil, derivedUser);
                        }
                    }
                    else {
                        completionHandler(error, nil);
                    }
                }];
            }
            else {
                completionHandler([NSError errorWithDomain:@"FacebookAuthError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"No Facebook accounts found."}], nil);
            }
        }
        else {
            completionHandler([NSError errorWithDomain:@"FacebookAuthError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"Facebook account access not granted."}], nil);
        }
    }];
}

#pragma mark - Facebook SDK

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    PACUser *derivedUser = [PACUser objectWithJSON:@{@"loginProvider": @(PACLoginProviderTypeFacebook), @"name": user.name, @"email": user[@"email"], @"loginId": user[@"email"], @"location": user.location.name, @"socialID": user.objectID}];
    if (self.delegate && [self.delegate respondsToSelector:@selector(successfullyDerivedUser:)])
        [self.delegate successfullyDerivedUser:derivedUser];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(failedToDeriveUserWithError:)])
        [self.delegate failedToDeriveUserWithError:error];
}

- (NSArray *)requiredPermissions {
    return @[@"public_profile", @"email", @"user_about_me", @"user_location"];
}

@end
