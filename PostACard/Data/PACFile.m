//
//  PACFile.m
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@interface NSString (FSURL)
/**
 Convert a filename into a file
 path with the standard fs documents
 directory.
 */
- (NSString *)standardFSURL;
@end

@implementation NSString (FSURL)
- (NSString *)standardFSURL {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:self];
}
@end

#import "PACFile.h"

@interface PACFile ()
@property (strong, readwrite, nonatomic) NSString *name;
@property (strong, readwrite, nonatomic) NSString *extension;
@property (strong, readwrite, nonatomic) NSString *HTTPContentType;
@property (strong, readwrite, nonatomic) NSString *filePath;
@end

@implementation PACFile

- (NSString *)description {
    return [NSString stringWithFormat:@"[Filename: %@, Path: %@]", self.filename, self.filePath];
}

- (void)purge {
    [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.extension forKey:@"extension"];
    [aCoder encodeObject:self.HTTPContentType forKey:@"HTTPContentType"];
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
        [self setExtension:[aDecoder decodeObjectForKey:@"extension"]];
        [self setHTTPContentType:[aDecoder decodeObjectForKey:@"HTTPContentType"]];
        [self setFilePath:[aDecoder decodeObjectForKey:@"filePath"]];
    }
    return self;
}

#pragma mark - Read

- (NSData *)data {
    return [NSData dataWithContentsOfFile:self.filePath];
}

- (NSString *)filename {
    return [self.name stringByAppendingString:[NSString stringWithFormat:@".%@", self.extension]];
}

#pragma mark - Write

- (NSString *)writeWithData:(NSData *)data {
    NSString *filePath = [self.filename standardFSURL];
    return [data writeToFile:filePath atomically:YES] ? filePath : nil;
}

#pragma mark - Init

+ (PACFile *)fileWithFileName:(NSString *)filename andData:(NSData *)data {
    return [[self alloc] initWithFileName:filename andData:data];
}

- (id)initWithFileName:(NSString *)filename andData:(NSData *)data {
    if (self = [self init]) {
        [self setName:[filename componentsSeparatedByString:@"."][0]];
        [self setExtension:[filename componentsSeparatedByString:@"."][1]];
        if ([self.extension isEqualToString:@"png"])
            [self setHTTPContentType:@"image/png"];
        else if ([self.extension isEqualToString:@"jpg"] || [self.extension isEqualToString:@"jpeg"])
            [self setHTTPContentType:@"image/jpeg"];
        [self setFilePath:[self writeWithData:data]];
    }
    return self;
}

- (id)init {
    return [super init];
}

@end
