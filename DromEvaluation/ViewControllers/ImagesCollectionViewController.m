//
//  ImagesCollectionViewController.m
//  DromEvaluation
//
//  Created by Paul Cherevach on 04.03.2024.
//

#import "ImagesCollectionViewController.h"
#import "ImagesLinksSource.h"
#import "ImagesLinksStubSource.h"
#import "NetworkingHelper.h"

@interface ImagesCollectionViewController ()

@end

@implementation ImagesCollectionViewController {
    __strong id<ImagesLinksSource> _imagesSource;
    __strong UICollectionViewDiffableDataSource *_dataSource;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout imagesSource:(id<ImagesLinksSource>) imagesSource {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _imagesSource = imagesSource;
        UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshControlPulled) forControlEvents:UIControlEventValueChanged];
        self.collectionView.refreshControl = refreshControl;
    }
    return self;
}

- (void)restoreCollectionContents {
    NSDiffableDataSourceSnapshot<NSNumber *, NSString *> *imagesSnapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    [imagesSnapshot appendSectionsWithIdentifiers: @[@0]];
    [imagesSnapshot appendItemsWithIdentifiers:_imagesSource.images];
    [_dataSource applySnapshot: imagesSnapshot animatingDifferences:YES];
    [self.collectionView.refreshControl endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ImageCell"];
    _dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider: [self makeCellProviderBlock]];
    self.collectionView.dataSource = _dataSource;
    self.collectionView.backgroundColor = UIColor.cyanColor;
    [self restoreCollectionContents];
}

- (UICollectionViewDiffableDataSourceCellProvider)makeCellProviderBlock {
    return ^UICollectionViewCell * _Nullable (UICollectionView *collectionView, NSIndexPath *indexPath, id itemIdentifier) {
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
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewDiffableDataSource *dataSource = (UICollectionViewDiffableDataSource *)collectionView.dataSource;
    NSDiffableDataSourceSnapshot<NSNumber *, NSString *> *currentSnapshot = dataSource.snapshot;
    NSString *itemIdentifier = [dataSource itemIdentifierForIndexPath:indexPath];
    [NetworkingHelper invalidateCachedRequest: [NetworkingHelper buildRequestFromURL:[NetworkingHelper buildURLFromString:itemIdentifier]]];
    [currentSnapshot deleteItemsWithIdentifiers:@[itemIdentifier]];
    [(UICollectionViewDiffableDataSource *)collectionView.dataSource applySnapshot:currentSnapshot animatingDifferences:YES];
}

#pragma mark UIRefreshControl action

- (void)refreshControlPulled {
    [NetworkingHelper invalidateAllCachedRequests];
    [self restoreCollectionContents];
}

@end
