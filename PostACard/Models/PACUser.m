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
#import "PACSocialPacket.h"
#import "PACSocialAuthFacebookClient.h"
#import "PACUser.h"

@interface PACUser ()
@property (readwrite, nonatomic) PACLoginProviderType loginProvider;
@property (strong, readwrite, nonatomic) NSString *loginId;
@property (strong, readwrite, nonatomic) NSString *name;
@property (strong, readwrite, nonatomic) NSString *email;
@property (strong, readwrite, nonatomic) NSDate *registrationDate;
@property (strong, readwrite, nonatomic) UIImage *profilePicture;
@property (strong, readwrite, nonatomic) PACSocialPacket *socialPacket;
@end

@implementation PACUser

- (NSString *)description {
    return [NSString stringWithFormat:@"[ID: %@, Login Provider: %lu, Login ID: %@, Name: %@, Email: %@, Registration Date: %@, Social Packet: %@]", self.ID, self.loginProvider, self.loginId, self.name, self.email, self.registrationDate, self.socialPacket];
}

#pragma mark - Download

- (BOOL)isDownloaded {
    return [super isDownloaded] && self.loginId && self.name && self.email && self.registrationDate && self.socialPacket;
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
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:UIImageJPEGRepresentation(self.profilePicture, 1.0f) forKey:@"profilePicure"];
    [aCoder encodeInteger:self.loginProvider forKey:@"loginProvider"];
    [aCoder encodeObject:self.loginId forKey:@"loginId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.registrationDate forKey:@"registrationDate"];
    [aCoder encodeObject:self.socialPacket forKey:@"socialPacket"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setProfilePicture:[UIImage imageWithData:[aDecoder decodeObjectForKey:@"profilePicture"]]];
        [self setLoginProvider:[aDecoder decodeIntegerForKey:@"loginProvider"]];
        [self setLoginId:[aDecoder decodeObjectForKey:@"loginId"]];
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
        [self setEmail:[aDecoder decodeObjectForKey:@"email"]];
        [self setRegistrationDate:[aDecoder decodeObjectForKey:@"registrationDate"]];
        [self setSocialPacket:[aDecoder decodeObjectForKey:@"socialPacket"]];
    }
    return self;
}

#pragma mark - Init

+ (PACUser *)objectWithJSON:(NSDictionary *)JSON {
    return [[self alloc] initWithJSON:JSON];
}

- (id)initWithJSON:(NSDictionary *)JSON {
    if (self = [super initWithJSON:JSON]) {
        [self setProfilePicture:[UIImage imageWithData:JSON[@"profilePicture"]]];
        [self setLoginProvider:(PACLoginProviderType)[JSON[@"loginProvider"] integerValue]];
        [self setLoginId:JSON[@"loginId"]];
        [self setName:JSON[@"name"]];
        [self setEmail:JSON[@"email"]];
        [self setRegistrationDate:[JSON[@"registrationDate"] NSDateFromISOString]];
        [self setSocialPacket:JSON[@"socialPacket"]];
    }
    return self;
}

- (id)init {
    return [super init];
}

@end