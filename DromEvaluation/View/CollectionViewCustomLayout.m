//
//  CollectionViewCustomLayout.m
//  DromEvaluation
//
//  Created by Paul Cherevach on 07.03.2024.
//

#import "CollectionViewCustomLayout.h"

@implementation CollectionViewCustomLayout

- (UICollectionViewLayout *)initLayout {
    NSCollectionLayoutDimension *width = [NSCollectionLayoutDimension fractionalWidthDimension:1];
    
    NSCollectionLayoutSize * itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:width heightDimension:width];
    NSCollectionLayoutItem * item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
    
    NSCollectionLayoutSize * groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:width heightDimension:width];
    NSCollectionLayoutGroup * group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:groupSize subitems:@[item]];
    
    NSCollectionLayoutSection * section = [NSCollectionLayoutSection sectionWithGroup:group];
    section.interGroupSpacing = 10;
    section.contentInsets = NSDirectionalEdgeInsetsMake(0, 10, 0, 10);
    
    self = [super initWithSection:section];
    return self;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    UICollectionViewLayoutAttributes *currentAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
    if (!currentAttributes) currentAttributes = self.crutchLastKnownItemAttributes;
    
    CGPoint currentPoint = currentAttributes.center;
    CGAffineTransform translation = CGAffineTransformMakeTranslation(self.collectionViewContentSize.width, 0);
    CGPoint newPoint = CGPointApplyAffineTransform(currentPoint, translation);
    currentAttributes.center = newPoint;
    
    return currentAttributes;
}

@end
