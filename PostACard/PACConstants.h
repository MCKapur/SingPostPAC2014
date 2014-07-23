//
//  PACConstants.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

/**
 This file stores all constants,
 and is imported in the Prefix
 file so variables can be globally
 available.
 */

/**
 The API URL base
 */
static
NSString *const APIURLBase = @"";

/* Social Auth Keys */

static NSString *const TwitterOAuthConsumerKey = @"";
static NSString *const TwitterOAuthConsumerSecret = @"";
static NSString *const InstagramAccessToken = @"";

/**
 ISO-8601 date format as returned from backend.
 */
static NSString *const ISODateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";

/**
 Alphanumeric char set.
 */
static NSString *const alphanumericSet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";

/* Endpoints */

static NSString *const InstagramSearchQueryEndpoint = @"GET->https://api.instagram.com/v1/users/search";

/**
 The login provider types.
 */
typedef NS_ENUM(NSInteger, PACLoginProviderType) {
    PACLoginProviderTypeEmail = 0,
    PACLoginProviderTypeFacebook,
    PACLoginProviderTypeTwitter,
    PACLoginProviderTypeInstagram
};

/**
 Different cache policies when querying data.
 */
typedef NS_ENUM (NSInteger, PACQueryRequestCachePolicy) {
    /**
     Query the backend first, if the operation fails,
     query the cache.
     */
    PACQueryRequestCachePolicyRemoteElseCache,
    /**
     Query the cache data only.
     */
    PACQueryRequestCachePolicyCacheOnly,
    /**
     Query the backend only.
     */
    PACQueryRequestCachePolicyRemoteOnly
};

/**
 The card template categories.
 */
typedef NS_ENUM(NSInteger, PACCardTemplateCategory) {
    PACCardTemplateCategoryPlaceholder
};

typedef NSOperationQueue PACQueryRequestQueue;
