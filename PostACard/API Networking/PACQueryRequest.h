//
//  PACQueryRequest.h
//  PostACard
//
//  Created by Rohan Kapur on 23/6/14.
//  Copyright (c) 2014 Rohan Kapur. All rights reserved.
//

@class PACQuery;
@class PACQueryResponse;

typedef void (^QueryRequestDispatchCompletionHandlerBlock)(PACQueryResponse *response);

/**
 A PACQueryRequest stores information
 like the query, timeout interval
 and the response for requests to
 the backend.
 ------------
 In addition, it is responsible
 for networking/querying the backend,
 and translating/delivering the response
 as a PACQueryResponse object.
 ------------
 It is a subclass of NSOperation
 and can be used with other operation
 objects and operation queues.
 */
@interface PACQueryRequest : NSOperation

/**
 The request's query object.
 */
@property (strong, readonly, nonatomic) PACQuery *query;

/**
 The request timeout interval,
 default is 60.0 seconds.
 */
@property (readwrite, nonatomic) NSUInteger timeoutInterval;

/**
 The request's response, initialized
 upon operation completion.
 */
@property (strong, readonly, nonatomic) PACQueryResponse *response;

/**
 Asynchronously dispatch the query
 request.
 */
- (void)asynchronouslyDispatchWithCompletionHandler:(QueryRequestDispatchCompletionHandlerBlock)completionHandler;

/**
 Returns a newly initialized
 PACQueryRequest object, with a
 query.
 */
+ (PACQueryRequest *)requestWithQuery:(PACQuery *)query;

/**
 Returns a newly initialized
 PACQueryRequest object, with
 a query.
 */
- (id)initWithQuery:(PACQuery *)query;

/**
 Returns a newly initialized
 PACQueryRequest object, with
 a query and timeout interval.
 */
+ (PACQueryRequest *)requestWithQuery:(PACQuery *)query andTimeoutInterval:(NSUInteger)timeoutInterval;

/**
 Returns a newly initialized
 PACQueryRequest object, with
 a query and timeout interval.
 */
- (id)initWithQuery:(PACQuery *)query andTimeoutInterval:(NSUInteger)timeoutInterval;

@end
