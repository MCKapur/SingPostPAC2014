//
//  PACSocialAuthFacebookClient.m
//  PostACard
//
//  Created by Rohan Kapur on 20/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import <FacebookSDK/FBRequest.h>
#import <FacebookSDK/FBErrorUtility.h>
#import <FacebookSDK/FBAccessTokenData.h>
#import <FacebookSDK/FBSession.h>

#import "PACDataStore.h"
#import "PACSocialPacket.h"
#import "PACModelObject.h"
#import "PACUser.h"
#import "PACSocialAuthFacebookClient.h"

@implementation PACSocialAuthFacebookClient

#pragma mark - Init

+ (instancetype)sharedClient {
    static PACSocialAuthFacebookClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

- (id)init {
    return [super init];
}

#pragma mark - Login

- (NSArray *)readPermissions {
    return @[@"public_profile", @"email"];
}

- (void)reviveCachedSessionWithCompletionHandler:(PACReviveCachedSessionCompletionHandlerBlock)completionHandler {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:[self readPermissions] allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            completionHandler([self sessionStateChanged:session state:state error:error]);
        }];
    }
}

- (void)loginWithCompletionHandler:(PACLoginCompletionHandlerBlock)completionHandler {
    [self loginOrLogoutWithCompletionHandler:completionHandler];
}

- (void)logoutWithCompletionHandler:(PACLogoutCompletionHandlerBlock)completionHandler {
    [self loginOrLogoutWithCompletionHandler:^(NSError *error, PACUser *user) {
        completionHandler(error);
    }];
}

- (void)loginOrLogoutWithCompletionHandler:(PACLoginCompletionHandlerBlock)completionHandler {
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
        completionHandler(nil, [[PACDataStore sharedStore] loggedInUser]);
    } else {
        [FBSession openActiveSessionWithReadPermissions:[self readPermissions] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            if (!error && state == FBSessionStateOpen) {
                [[NSNotificationCenter defaultCenter] postNotificationName:PACNotificationLoggingIn object:nil];
                [self downloadProfileWithCompletionHandler:completionHandler];
            }
            else {
                completionHandler([self sessionStateChanged:session state:state error:error], nil);
            }
         }];
    }
}

#pragma mark - Session Handling

- (NSError *)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    NSError *finalError = [NSError errorWithDomain:@"AuthError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"Unknown error."}];
    if (!error && state == FBSessionStateOpen)
        finalError = nil;
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed)
        finalError = nil;
    if (error) {
        NSString *alertText = @"";
        NSString *alertTitle = @"";
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES) {
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
        }
        else {
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            }
            else if ([FBErrorUtility errorCategoryForError:error] ==FBErrorCategoryAuthenticationReopenSession) {
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
            } else {
                NSDictionary *errorInformation = error.userInfo [@"com.facebook.sdk:ParsedJSONResponseKey"][@"body"][@"error"];
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", errorInformation[@"message"]];
            }
        }
        [NSError errorWithDomain:@"AuthError" code:400 userInfo:@{NSLocalizedDescriptionKey: [alertTitle stringByAppendingFormat:@": %@", alertText]}];
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    return finalError;
}

- (void)handleColdStartWithCompletionHandler:(PACHandleColdStartCompletionHandlerBlock)completionHandler {
    [FBSession.activeSession setStateChangeHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
        completionHandler(error);
     }];
}

#pragma mark - Requests

- (void)downloadProfileWithCompletionHandler:(PACLoginCompletionHandlerBlock)completionHandler {
    if ([FBSession activeSession].isOpen) {
        [FBRequestConnection startWithGraphPath:@"me" parameters:@{@"fields": @"id,name,first_name,last_name,email,picture"} HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSDictionary<FBGraphUser> *user = result;
            NSLog(@"%@", user);
            if (!error) {
               __block UIImage *profilePicture = nil;
                if (user[@"picture"]) {
                    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[user[@"picture"][@"data"][@"url"] stringByReplacingOccurrencesOfString:@"50x50" withString:@"200x200"]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        if (!connectionError && [UIImage imageWithData:data])
                            profilePicture = [UIImage imageWithData:data];
                        PACSocialPacket *packet = [[PACSocialPacket alloc] initWithID:user[@"id"] andAccessToken:[FBSession activeSession].accessTokenData.accessToken];
                        PACUser *derivedUser = [PACUser objectWithJSON:@{@"profilePicture": UIImageJPEGRepresentation(profilePicture, 1.0f), @"_id": @"0", @"loginProvider": @(PACLoginProviderTypeFacebook), @"name": [user[@"first_name"] stringByAppendingFormat:@" %@", user[@"last_name"]], @"registrationDate": [[NSDate date] ISOStringFromNSDate], @"email": user[@"email"], @"socialPacket": packet}];
                        completionHandler(nil, derivedUser);
                    }];
                    
                }
                else {
                    PACSocialPacket *packet = [[PACSocialPacket alloc] initWithID:user[@"id"] andAccessToken:[FBSession activeSession].accessTokenData.accessToken];
                    PACUser *derivedUser = [PACUser objectWithJSON:@{@"_id": @"0", @"loginProvider": @(PACLoginProviderTypeFacebook), @"name": [user[@"first_name"] stringByAppendingFormat:@" %@", user[@"last_name"]], @"registrationDate": [[NSDate date] ISOStringFromNSDate], @"email": user[@"email"], @"socialPacket": packet}];
                    completionHandler(nil, derivedUser);
                }
            }
            else {
                completionHandler(error, nil);
            }
        }];
    }
    else {
        completionHandler([NSError errorWithDomain:@"AuthError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"Unknown error."}], nil);
    }
}

@end
