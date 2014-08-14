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

#define UIColorActualRGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

/**
 The API URL base
 */
static NSString *const APIURLBase = @"";

/* URL Hosts */

static NSString *const PACTakeImageURLHost = @"post-a-card-take-image-scheme.com";

/* Social Auth Keys */

static NSString *const PACTwitterOAuthConsumerKey = @"";
static NSString *const PACTwitterOAuthConsumerSecret = @"";
static NSString *const PACInstagramAccessToken = @"";

/* Local Notifications */

static NSString *const PACNotificationLoggedIn = @"PACNotificationLoggedIn";
static NSString *const PACNotificationLoggingIn = @"PACNotificationLoggingIn";

/* Tab bar icon image paths */
static NSString *const PACCategoriesTabBarIconImage_NotSelected = @"ic_tabbar_categories_unselected.png";
static NSString *const PACCategoriesTabBarIconImage_Selected = @"ic_tabbar_categories_selected.png";
static NSString *const PACProfileTabBarIconImage_NotSelected = @"ic_tabbar_profile_unselected.png";
static NSString *const PACProfileTabBarIconImage_Selected = @"ic_tabbar_profile_selected.png";

/* Glyph icon image paths */
static NSString *const PACComposeIconImage = @"ic_compose_photo.png";

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
 The content consumption (interaction) modes
 for card views.
 */
typedef NS_ENUM(NSInteger, PACCardViewContentConsumptionMode) {
    PACCardViewContentConsumptionModePreview = 0,
    PACCardViewContentConsumptionModeView,
    PACCardViewContentConsumptionModeEdit
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

typedef NSOperationQueue PACQueryRequestQueue;
