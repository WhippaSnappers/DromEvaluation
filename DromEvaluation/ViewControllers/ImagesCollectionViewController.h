//
//  ImagesCollectionViewController.h
//  DromEvaluation
//
//  Created by Paul Cherevach on 04.03.2024.
//

#import <UIKit/UIKit.h>
#import "ImagesLinksSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImagesCollectionViewController : UICollectionViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout imagesSource:(id<ImagesLinksSource>)imagesSource;

@end

NS_ASSUME_NONNULL_END
