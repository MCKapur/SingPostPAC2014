//
//  PACSocialAuthInstagramClient.m
//  PostACard
//
//  Created by Rohan Kapur on 20/7/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACUser.h"
#import "PACQuery.h"
#import "PACQueryPayload.h"
#import "PACQueryResponse.h"
#import "PACQueryRequest.h"
#import "PACSocialAuthInstagramClient.h"

@implementation PACSocialAuthInstagramClient

- (void)deriveBasicUserFromInstagramUsername:(NSString *)username withCompletionHandler:(UserDownloadCompletionHandler)completionHandler {
    PACQueryPayload *payload = [PACQueryPayload payload];
    [payload.body setObject:username forKey:@"q"];
    [payload.body setObject:@(1) forKey:@"count"];
    [payload.body setObject:InstagramAccessToken forKey:@"access_token"];
    PACQueryRequest *request = [PACQueryRequest requestWithQuery:[PACQuery queryWithAPIEndpointIdentifier:InstagramSearchQueryEndpoint payload:payload andHeaders:nil]];
    PACQueryRequestQueue *queue = [[PACQueryRequestQueue alloc] init];
    [queue addOperation:request];
    [queue waitUntilAllOperationsAreFinished];
    PACQueryResponse *response = request.response;
    if (!response.error && response.parsedData) {
        if (((NSArray *)response.parsedData[@"data"]).count) {
            PACUser *derivedUser = [PACUser objectWithJSON:@{@"loginProvider": @(PACLoginProviderTypeInstagram), @"name": [response.parsedData[@"data"][0][@"first_name"] stringByAppendingFormat:@" %@", response.parsedData[@"data"][0][@"last_name"]], @"socialID": response.parsedData[@"data"][0][@"id"]}];
            completionHandler(nil, derivedUser);
        }
        else {
            completionHandler([NSError errorWithDomain:@"AuthError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"No Instagram accounts found."}], nil);
        }
    }
    else {
        completionHandler([NSError errorWithDomain:@"AuthError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"Unknown auth error."}], nil);
    }
}

@end