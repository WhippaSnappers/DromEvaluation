//
//  CellProviderBlock.m
//  DromEvaluation
//
//  Created by Paul Cherevach on 07.03.2024.
//

#import <Foundation/Foundation.h>
#import "CellProviderBlock.h"
#import "NetworkingHelper.h"

static UICollectionViewDiffableDataSourceCellProvider cellProviderBlock = ^UICollectionViewCell * _Nullable (UICollectionView *collectionView, NSIndexPath *indexPath, id itemIdentifier) {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    DownloadingTaskCompletionHandlerBlock completionHandler = ^void(NSData * data, NSURLResponse * response, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage * img = [UIImage imageWithData:data];
            UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
            cell.backgroundView = imgView;
        });
    };
    NSString *imageURLString = (NSString *)itemIdentifier;
    NSURLSessionDataTask * imageDownloadingTask = [NetworkingHelper buildImageDownloadingTaskFromRequest:[NetworkingHelper buildRequestFromURL:[NetworkingHelper buildURLFromString:imageURLString]] completionHandler:completionHandler];
    [imageDownloadingTask resume];
    
    return cell;
};

