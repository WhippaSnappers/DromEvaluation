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
#import "CollectionViewCustomLayout.h"

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
    NSDiffableDataSourceSnapshot<NSNumber *, NSString *> *imagesSnapshot = [_dataSource snapshot];
    [imagesSnapshot deleteAllItems];
    [imagesSnapshot appendSectionsWithIdentifiers: @[@0]];
    [imagesSnapshot appendItemsWithIdentifiers:_imagesSource.images];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^(void) {
        [self->_dataSource applySnapshot:imagesSnapshot animatingDifferences:YES];
    });
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

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *crutchAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
//    Used particularly to animate the tail element being deleted since its attributes are, for some reason, gone right after the new snapshot is applied
    ((CollectionViewCustomLayout *)self.collectionView.collectionViewLayout).crutchLastKnownItemAttributes = crutchAttributes;
    
    NSString *itemIdentifier = [_dataSource itemIdentifierForIndexPath:indexPath];
    [NetworkingHelper invalidateCachedRequest: [NetworkingHelper buildRequestFromURL:[NetworkingHelper buildURLFromString:itemIdentifier]]];
    
    NSDiffableDataSourceSnapshot<NSNumber *, NSString *> *currentSnapshot = [_dataSource snapshot];
    [currentSnapshot deleteItemsWithIdentifiers:@[itemIdentifier]];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^(void) {
        [self->_dataSource applySnapshot:currentSnapshot animatingDifferences:YES];
    });
}

#pragma mark UIRefreshControl action

- (void)refreshControlPulled {
    [NetworkingHelper invalidateAllCachedRequests];
    NSDiffableDataSourceSnapshot<NSNumber *, NSString *> *currentSnapshot = [_dataSource snapshot];
    [currentSnapshot deleteAllItems];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^(void) {
        [self->_dataSource applySnapshot:currentSnapshot animatingDifferences:YES];
    });
    [self restoreCollectionContents];
}

#pragma mark CellProviderBlock

- (UICollectionViewDiffableDataSourceCellProvider)makeCellProviderBlock {
    return ^UICollectionViewCell * _Nullable (UICollectionView *collectionView, NSIndexPath *indexPath, id itemIdentifier) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        
        DownloadingTaskCompletionHandlerBlock completionHandler = ^void(NSData * data, NSURLResponse * response, NSError * error) {
            UIImage * img = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
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

@end
