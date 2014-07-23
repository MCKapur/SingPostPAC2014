//
//  PACCardTemplate.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

#import "PACCardTemplate.h"
#import "PACNetworkingManager.h"
#import "PACQueryPayload.h"
#import "PACQueryPayload+ModularComposer.h"
#import "PACCardView.h"

@interface PACCardTemplate ()
@property (strong, readwrite, nonatomic) PACCardView *frontView;
@property (strong, readwrite, nonatomic) PACCardView *backView;
@property (readwrite, nonatomic) PACCardTemplateCategory category;
@property (strong, readwrite, nonatomic) NSString *title;
@property (strong, readwrite, nonatomic) NSString *biography;
@property (strong, readwrite, nonatomic) NSDate *availabilityDate;
@end

@implementation PACCardTemplate

- (NSString *)description {
    return [NSString stringWithFormat:@"[ID: %@, Front View: %@, Back View: %@, Category: %ldl, Title: %@, Biography: %@, Availability Date: %@]", self.ID, self.frontView, self.backView, self.category, self.title, self.biography, self.availabilityDate];
}

#pragma mark - Download

- (BOOL)isDownloaded {
    return [super isDownloaded] && self.frontView && self.backView && self.title && self.biography && self.availabilityDate;
}

- (void)downloadWithCachePolicy:(PACQueryRequestCachePolicy)cachePolicy completionHandler:(DownloadCompletionHandlerBlock)completionHandler {
    if (!self.ID) {
        if (completionHandler)
            completionHandler([NSError errorWithDomain:@"ModelDownloadError" code:400 userInfo:@{NSLocalizedDescriptionKey: @"No ID provided to the model."}], nil);
        return;
    }
    //    CRQueryPayload *payload = [CRQueryPayload payload];
    //    [payload addSearchCardTemplateIds:@[self.ID]];
    //    [[CRNetworkingManager sharedManager] searchCardTemplatesWithQueryPayload:payload withCachePolicy:cachePolicy completionHandler:^(NSError *error, NSArray *cardTemplates, BOOL isCache) {
    //        if (completionHandler)
    //            completionHandler(error, cardTemplates.count ? cardTemplates[0] : nil);
    //    }];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.frontView forKey:@"frontView"];
    [aCoder encodeObject:self.backView forKey:@"backView"];
    [aCoder encodeInteger:self.category forKey:@"category"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.biography forKey:@"biography"];
    [aCoder encodeObject:self.availabilityDate forKey:@"availabilityDate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setFrontView:[aDecoder decodeObjectForKey:@"frontView"]];
        [self setBackView:[aDecoder decodeObjectForKey:@"backView"]];
        [self setCategory:(PACCardTemplateCategory)[aDecoder decodeIntegerForKey:@"category"]];
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setBiography:[aDecoder decodeObjectForKey:@"biography"]];
        [self setAvailabilityDate:[aDecoder decodeObjectForKey:@"availabilityDate"]];
    }
    return self;
}

#pragma mark - Init

+ (PACCardTemplate *)objectWithJSON:(NSDictionary *)JSON {
    return [[self alloc] initWithJSON:JSON];
}

- (id)initWithJSON:(NSDictionary *)JSON {
    if (self = [super initWithJSON:JSON]) {
        [self setFrontView:[PACCardView cardViewWithHTML:JSON[@"frontViewHTML"]]];
        [self setBackView:[PACCardView cardViewWithHTML:JSON[@"backViewHTML"]]];
        [self setCategory:(PACCardTemplateCategory)[JSON[@"category"] integerValue]];
        [self setTitle:JSON[@"title"]];
        [self setBiography:JSON[@"biography"]];
        [self setAvailabilityDate:[JSON[@"availabilityDate"] NSDateFromISOString]];
    }
    return self;
}

- (id)init {
    return [super init];
}

@end