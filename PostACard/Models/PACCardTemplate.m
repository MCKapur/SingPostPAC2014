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

@interface PACCardTemplate ()
@property (strong, readwrite, nonatomic) NSString *HTML;
@property (readwrite, nonatomic) NSString *category;
@property (strong, readwrite, nonatomic) NSDate *availabilityDate;
@end

@implementation PACCardTemplate

- (NSString *)description {
    return [NSString stringWithFormat:@"[ID: %@, HTML: %@, Category: %@, Availability Date: %@]", self.ID, self.HTML, self.category, self.availabilityDate];
}

#pragma mark - Download

- (BOOL)isDownloaded {
    return [super isDownloaded] && self.HTML && self.availabilityDate && self.category;
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
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.HTML forKey:@"HTML"];
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.availabilityDate forKey:@"availabilityDate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setHTML:[aDecoder decodeObjectForKey:@"HTML"]];
        [self setCategory:[aDecoder decodeObjectForKey:@"category"]];
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
        [self setHTML:JSON[@"HTML"]];
        [self setCategory:JSON[@"category"]];
        [self setAvailabilityDate:[JSON[@"availabilityDate"] NSDateFromISOString]];
    }
    return self;
}

- (id)init {
    return [super init];
}

@end