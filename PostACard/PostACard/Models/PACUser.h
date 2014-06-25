//
//  PACUser.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACModelObject.h"

/**
 A PACUser represents a client-
 side user object.
 */
@interface PACUser : PACModelObject

/**
 The service used to sign
 up with the account.
 */
@property (readonly, nonatomic) PACLoginProviderType loginProvider;

/**
 The email or service API
 ID/code used to sign up
 with the account, varies
 on the login provider.
 */
@property (strong, readonly, nonatomic) NSString *loginId;

/**
 The user's full name.
 */
@property (strong, readonly, nonatomic) NSString *name;

/**
 The user's email.
 */
@property (strong, readonly, nonatomic) NSString *email;

/**
 The user's address.
 */
@property (strong, readonly, nonatomic) NSString *address;

/**
 The user's registration date.
 */
@property (strong, readonly, nonatomic) NSDate *registrationDate;

@end