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
@interface PACFile : NSObject

/**
 The file's name/key.
 */
@property (strong, readonly, nonatomic) NSString *name;

/**
 The file's extension.
 */
@property (strong, readonly, nonatomic) NSString *extension;

/**
 The path to the file.
 */
@property (strong, readonly, nonatomic) NSString *filePath;

/**
 Returns a newly initialized
 PACFile with a filename and
 file data.
 */
+ (PACFile *)fileWithFileName:(NSString *)filename andData:(NSData *)data;

/**
 Returns a newly initialized
 PACFile with a filename and
 file data.
 */
- (id)initWithFileName:(NSString *)filename andData:(NSData *)data;

/**
 Synchronously read and
 return the file's data
 in stream, NSData form.
 */
- (NSData *)data;

/**
 Returns the file's name
 and extension attached
 together to form a file-
 name.
 */
- (NSString *)filename;

/**
 Delete the file from
 the file system.
 */
- (void)purge;

@end
