//
//  NetworkingHelper.h
//  DromEvaluation
//
//  Created by Paul Cherevach on 07.03.2024.
//

#import <Foundation/Foundation.h>
#import "Typedefs.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkingHelper : NSObject

+ (NSURL *)buildURLFromString:(NSString *)string;
+ (NSURLRequest *)buildRequestFromURL:(NSURL *)url;
+ (NSURLSessionDataTask *)buildImageDownloadingTaskFromRequest:(NSURLRequest *)request completionHandler:(DownloadingTaskCompletionHandlerBlock) completionHandler;
+ (void)invalidateCachedRequest:(NSURLRequest *)request;
+ (void)invalidateAllCachedRequests;

@end

NS_ASSUME_NONNULL_END
