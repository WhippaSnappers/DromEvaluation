//
//  NetworkingHelper.m
//  DromEvaluation
//
//  Created by Paul Cherevach on 07.03.2024.
//

#import "NetworkingHelper.h"
#import "UIKit/UIImage.h"
#import "UIKit/UIImageView.h"
#import "UIKit/UICollectionViewCell.h"

@implementation NetworkingHelper

+ (NSURL *)buildURLFromString:(NSString *)string {
    return [NSURL URLWithString:string];
}

+ (NSURLRequest *)buildRequestFromURL:(NSURL *)url {
    return [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:0];
}

static UICollectionViewCell *cell;
+ (NSURLSessionDataTask *)buildImageDownloadingTaskFromRequest:(NSURLRequest *)request completionHandler:(DownloadingTaskCompletionHandlerBlock) completionHandler {
    return [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:completionHandler];
}

+ (void)invalidateCachedRequest:(nonnull NSURLRequest *)request {
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    [sharedCache removeCachedResponseForRequest:request];
}

+ (void)invalidateAllCachedRequests {
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    [sharedCache removeAllCachedResponses];
}

@end
