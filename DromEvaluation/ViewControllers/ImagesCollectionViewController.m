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
#import "ImageCollectionViewCell.h"

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
    [self.collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"ImageCell"];
    _dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider: [self makeCellProviderBlock]];
    self.collectionView.dataSource = _dataSource;
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self restoreCollectionContents];
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    static BOOL busy;
//  Nasty bugs might arise if the user tries to delete multiple cells simultaneously
    if (busy) return;
    busy = YES;
    
    UICollectionViewCell *selectedItemCell = [collectionView cellForItemAtIndexPath:indexPath];
    NSUInteger animationDuration = 1;

    [self.collectionView performBatchUpdates:^void {
        [UIView animateWithDuration:animationDuration animations:^void {
            CGPoint newPoint = CGPointMake(collectionView.bounds.size.width - 1, selectedItemCell.center.y);
            selectedItemCell.anchorPoint = CGPointMake(0, 0.5);
            selectedItemCell.center = newPoint;
        }];
    } completion:^void(BOOL completed) {
        // Deleting from DiffableDataSource only after animations are done
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            selectedItemCell.hidden = YES;
            
            NSString *itemIdentifier = [self->_dataSource itemIdentifierForIndexPath:indexPath];
            [NetworkingHelper invalidateCachedRequest: [NetworkingHelper buildRequestFromURL:[NetworkingHelper buildURLFromString:itemIdentifier]]];
            NSDiffableDataSourceSnapshot<NSNumber *, NSString *> *currentSnapshot = [self->_dataSource snapshot];
            [currentSnapshot deleteItemsWithIdentifiers:@[itemIdentifier]];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^(void) {
                [self->_dataSource applySnapshot:currentSnapshot animatingDifferences:YES];
            });
            busy = NO;
        });
    }];
}

#pragma mark UIRefreshControl action

- (void)refreshControlPulled {
    [NetworkingHelper invalidateAllCachedRequests];
    NSDiffableDataSourceSnapshot<NSNumber *, NSString *> *currentSnapshot = [_dataSource snapshot];
    [currentSnapshot deleteAllItems];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^(void) {
        [self->_dataSource applySnapshot:currentSnapshot animatingDifferences:NO];
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
