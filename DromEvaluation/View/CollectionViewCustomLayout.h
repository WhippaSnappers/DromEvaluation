//
//  CollectionViewCustomLayout.h
//  DromEvaluation
//
//  Created by Paul Cherevach on 07.03.2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCustomLayout : UICollectionViewCompositionalLayout

@property(strong) UICollectionViewLayoutAttributes *crutchLastKnownItemAttributes;

- (UICollectionViewLayout *)initLayout;
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath;

@end

NS_ASSUME_NONNULL_END
