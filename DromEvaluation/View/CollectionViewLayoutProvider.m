//
//  CollectionViewLayoutProvider.m
//  DromEvaluation
//
//  Created by Paul Cherevach on 07.03.2024.
//

#import "CollectionViewLayoutProvider.h"

@implementation CollectionViewLayoutProvider

+ (UICollectionViewCompositionalLayout *)customLayout {
    NSCollectionLayoutSize * itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1] heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1]];
    NSCollectionLayoutItem * item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
    
    NSCollectionLayoutSize * groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1] heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1]];
    NSCollectionLayoutGroup * group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:groupSize subitems:@[item]];
    
    NSCollectionLayoutSection * section = [NSCollectionLayoutSection sectionWithGroup:group];
    section.interGroupSpacing = 10;
    section.contentInsets = NSDirectionalEdgeInsetsMake(0, 10, 0, 10);
    
    return [[UICollectionViewCompositionalLayout alloc] initWithSection:section];
}

@end
