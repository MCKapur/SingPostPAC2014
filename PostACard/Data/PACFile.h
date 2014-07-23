//
//  PACFile.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

/**
 A PACFile holds relevant
 file information like the
 file name, file extension,
 file path and provides access
 to the physical data.
 */
@interface PACFile : NSObject <NSCoding>

/**
 The file's name.
 */
@property (strong, readonly, nonatomic) NSString *name;

/**
 The file's extension.
 */
@property (strong, readonly, nonatomic) NSString *extension;

/**
 The file type for HTTP requests.
 */
@property (strong, readonly, nonatomic) NSString *HTTPContentType;

/**
 The path to the file.
 */
@property (strong, readonly, nonatomic) NSString *filePath;

/**
 Returns a newly initialized
 PACFile with a filename and
 data.
 */
+ (PACFile *)fileWithFileName:(NSString *)filename andData:(NSData *)data;

/**
 Returns a newly initialized
 PACFile with a filename and
 data.
 */
- (id)initWithFileName:(NSString *)filename andData:(NSData *)data;

/**
 Returns the file's raw data.
 */
- (NSData *)data;

/**
 Returns the file's name and
 extension attached together to
 form a filename.
 */
- (NSString *)filename;

/**
 Delete the file data from the
 file system.
 */
- (void)purge;

@end
