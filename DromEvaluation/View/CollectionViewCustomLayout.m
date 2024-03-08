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

@end
