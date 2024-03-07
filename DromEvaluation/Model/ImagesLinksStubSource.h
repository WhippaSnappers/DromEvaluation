//
//  ImagesSource.h
//  DromEvaluation
//
//  Created by Paul Cherevach on 05.03.2024.
//

#import <Foundation/Foundation.h>
#import "ImagesLinksSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImagesLinksStubSource : NSObject <ImagesLinksSource>

@property(strong, readonly) NSArray *images;

@end

NS_ASSUME_NONNULL_END
