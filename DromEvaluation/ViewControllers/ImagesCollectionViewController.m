//
//  ImagesCollectionViewController.m
//  DromEvaluation
//
//  Created by Paul Cherevach on 04.03.2024.
//

#import "ImagesCollectionViewController.h"
#import "ImagesLinksSource.h"
#import "ImagesLinksStubSource.h"
#import "CellProviderBlock.h"
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
        [self initCollectionViewDiffableDataSource];
    }
    return self;
}

- (void)initCollectionViewDiffableDataSource {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = UIColor.cyanColor;
    _dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider: cellProviderBlock];
    self.collectionView.dataSource = _dataSource;
    NSDiffableDataSourceSnapshot<NSNumber *, NSNumber *> *imagesSnapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    [imagesSnapshot appendSectionsWithIdentifiers: @[@0]];
    [imagesSnapshot appendItemsWithIdentifiers:@[@0] intoSectionWithIdentifier:@0];
    [_dataSource applySnapshot: imagesSnapshot animatingDifferences:NO];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
