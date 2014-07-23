//
//  PACCard.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACNetworkingManager.h"
#import "PACUser.h"
#import "PACCard.h"

@interface PACCard ()
@property (strong, readwrite, nonatomic) PACUser *publisher;
@property (strong,  readwrite, nonatomic) NSDate *publishDate;
@property (strong, readwrite, nonatomic) NSString *extendedMessage;
@end

@implementation PACCard

- (NSString *)description {
    return [NSString stringWithFormat:@"[ID: %@, Publisher: %@, Publish Date: %@, Extended Message: %@]", self.ID, self.publisher, self.publishDate, self.extendedMessage];
}

#pragma mark - Download

- (BOOL)isDownloaded {
    return [super isDownloaded] && self.publisher && self.publishDate && self.extendedMessage;
}

- (void)downloadWithCachePolicy:(PACQueryRequestCachePolicy)cachePolicy completionHandler:(DownloadCompletionHandlerBlock)completionHandler {
    if (!self.ID) {
        if (completionHandler)
            completionHandler([NSError errorWithDomain:@"ModelDownloadError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"No ID provided to the model."}], nil);
        return;
    }
    //    CRQueryPayload *payload = [CRQueryPayload payload];
    //    [payload addSearchCardIds:@[self.ID]];
    //    [[CRNetworkingManager sharedManager] searchCardsWithQueryPayload:payload withCachePolicy:cachePolicy completionHandler:^(NSError *error, NSArray *cards, BOOL isCache) {
    //        if (completionHandler)
    //            completionHandler(error, cards.count ? cards[0] : nil);
    //    }];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.publisher forKey:@"publisher"];
    [aCoder encodeObject:self.publishDate forKey:@"publishDate"];
    [aCoder encodeObject:self.extendedMessage forKey:@"extendedMessage"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setPublisher:[aDecoder decodeObjectForKey:@"publisher"]];
        [self setPublishDate:[aDecoder decodeObjectForKey:@"publishDate"]];
        [self setExtendedMessage:[aDecoder decodeObjectForKey:@"extendedMessage"]];
    }
    return self;
}

#pragma mark - Init

+ (PACCard *)objectWithJSON:(NSDictionary *)JSON {
    return [[self alloc] initWithJSON:JSON];
}

- (id)initWithJSON:(NSDictionary *)JSON {
    if (self = [super initWithJSON:JSON]) {
        [self setPublisher:[PACUser objectWithJSON:JSON[@"publisher"]]];
        [self setPublishDate:[JSON[@"publishDate"] NSDateFromISOString]];
        [self setExtendedMessage:JSON[@"extendedMessage"]];
    }
    return self;
}

- (id)init {
    return [super init];
}

@end

