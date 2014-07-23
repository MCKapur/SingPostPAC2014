//
//  PACUser.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACNetworkingManager.h"
#import "PACQueryPayload.h"
#import "PACQueryPayload+ModularComposer.h"
#import "PACUser.h"

@interface PACUser ()
@property (readwrite, nonatomic) PACLoginProviderType loginProvider;
@property (strong, readwrite, nonatomic) NSString *loginId;
@property (strong, readwrite, nonatomic) NSString *name;
@property (strong, readwrite, nonatomic) NSString *email;
@property (strong, readwrite, nonatomic) NSString *location;
@property (strong, readwrite, nonatomic) NSString *address;
@property (strong, readwrite, nonatomic) NSDate *registrationDate;
@property (strong, readwrite, nonatomic) NSString *socialID;
@end

@implementation PACUser

- (NSString *)description {
    return [NSString stringWithFormat:@"[ID: %@, Login Provider: %lu, Login ID: %@, Name: %@, Email: %@, Location: %@, Address: %@, Registration Date: %@, Social ID: %@]", self.ID, self.loginProvider, self.loginId, self.name, self.email, self.location, self.address, self.registrationDate, self.socialID];
}

#pragma mark - Download

- (BOOL)isDownloaded {
    return [super isDownloaded] && self.loginId && self.name && self.email && self.location && self.address && self.registrationDate && self.socialID;
}

- (void)downloadWithCachePolicy:(PACQueryRequestCachePolicy)cachePolicy completionHandler:(DownloadCompletionHandlerBlock)completionHandler {
    if (!self.ID) {
        if (completionHandler)
            completionHandler([NSError errorWithDomain:@"ModelDownloadError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"No ID provided to the model."}], nil);
        return;
    }
//    CRQueryPayload *payload = [CRQueryPayload payload];
//    [payload addSearchUserIds:@[self.ID]];
//    [[CRNetworkingManager sharedManager] searchUsersWithQueryPayload:payload withCachePolicy:cachePolicy completionHandler:^(NSError *error, NSArray *users, BOOL isCache) {
//        if (completionHandler)
//            completionHandler(error, users.count ? users[0] : nil);
//    }];
}

- (void)downloadPhotoSetWithCompletionHandler:(PhotoSetDownloadCompletionHandler)completionHandler {
    if (self.loginProvider == PACLoginProviderTypeFacebook) {
        
    }
    else if (self.loginProvider == PACLoginProviderTypeTwitter) {
        
    }
    else if (self.loginProvider == PACLoginProviderTypeInstagram) {
        
    }
    else {
        
    }
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.loginProvider forKey:@"loginProvider"];
    [aCoder encodeObject:self.loginId forKey:@"loginId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.registrationDate forKey:@"registrationDate"];
    [aCoder encodeObject:self.socialID forKey:@"socialID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setLoginProvider:[aDecoder decodeIntegerForKey:@"loginProvider"]];
        [self setLoginId:[aDecoder decodeObjectForKey:@"loginId"]];
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
        [self setEmail:[aDecoder decodeObjectForKey:@"email"]];
        [self setLocation:[aDecoder decodeObjectForKey:@"location"]];
        [self setAddress:[aDecoder decodeObjectForKey:@"address"]];
        [self setRegistrationDate:[aDecoder decodeObjectForKey:@"registrationDate"]];
        [self setSocialID:[aDecoder decodeObjectForKey:@"socialID"]];
    }
    return self;
}

#pragma mark - Init

+ (PACUser *)objectWithJSON:(NSDictionary *)JSON {
    return [[self alloc] initWithJSON:JSON];
}

- (id)initWithJSON:(NSDictionary *)JSON {
    if (self = [super initWithJSON:JSON]) {
        [self setLoginProvider:(PACLoginProviderType)[JSON[@"loginProvider"] integerValue]];
        [self setLoginId:JSON[@"loginId"]];
        [self setName:JSON[@"name"]];
        [self setEmail:JSON[@"email"]];
        [self setLocation:JSON[@"location"]];
        [self setAddress:JSON[@"address"]];
        [self setRegistrationDate:[JSON[@"registrationDate"] NSDateFromISOString]];
        [self setSocialID:JSON[@"socialID"]];
    }
    return self;
}

- (id)init {
    return [super init];
}

@end