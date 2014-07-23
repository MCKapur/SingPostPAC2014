//
//  PACNetworkingManager.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@class PACCard;
@class PACUser;
@class PACQueryPayload;

typedef void (^LoginRegisterUserCompletionHandlerBlock)(NSError *error, PACUser *user);
typedef void (^SearchCompletionHandlerBlock)(NSError *error, NSArray *results);
typedef void (^PublishCardCompletionHandlerBlock)(NSError *error, PACCard *card);

/**
 The PACNetworkingManager provides
 an effortless, verbose interface
 for sending requests to the backend,
 and/or from the local in-mem data
 store.
 */
@interface PACNetworkingManager : NSObject

/**
 Register a PACUser with a query payload.
 */
- (void)registerUserWithQueryPayload:(PACQueryPayload *)queryPayload completionHandler:(LoginRegisterUserCompletionHandlerBlock)completionHandler;

/**
 Login to a PACUser with a login ID and token.
 */
- (void)loginToUserWithLoginId:(NSString *)loginId andToken:(NSString *)loginToken completionHandler:(LoginRegisterUserCompletionHandlerBlock)completionHandler;

/**
 Search for PACCardTemplates with a query
 payload and cache policy.
 */
- (void)searchCardTemplatesWithQueryPayload:(PACQueryPayload *)queryPayload andCachePolicy:(PACQueryRequestCachePolicy)cachePolicy completionHandler:(SearchCompletionHandlerBlock)completionHandler;

/**
 Search for PACCards.
 */
- (void)searchCardsWithQueryPayload:(PACQueryPayload *)queryPayload andCachePolicy:(PACQueryRequestCachePolicy)cachePolicy completionHandler:(SearchCompletionHandlerBlock)completionHandler;

/**
 Publish a PACCard.
 */
- (void)publishCardWithQueryPayload:(PACQueryPayload *)queryPayload completionHandler:(PublishCardCompletionHandlerBlock)completionHandler;

@end
