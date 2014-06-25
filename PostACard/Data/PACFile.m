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
@property (strong, readwrite, nonatomic) NSString *filePath;
@end

@implementation PACFile

- (NSString *)description {
    return [NSString stringWithFormat:@"[Filename: %@, Path: %@]", self.filename, self.filePath];
}

- (void)purge {
    [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
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
    [self.data writeToFile:filePath atomically:YES];
    return filePath;
}

#pragma mark - Init

+ (PACFile *)fileWithFileName:(NSString *)filename andData:(NSData *)data {
    return [[self alloc] initWithFileName:filename andData:data];
}

- (id)initWithFileName:(NSString *)filename andData:(NSData *)data {
    if (self = [self init]) {
        [self setName:[filename componentsSeparatedByString:@"."][0]];
        [self setExtension:[filename componentsSeparatedByString:@"."][1]];
        [self setFilePath:[self writeWithData:data]];
    }
    return self;
}

- (id)init {
    return [super init];
}

@end
