//
//  Image.h
//  DromEvaluation
//
//  Created by Paul Cherevach on 05.03.2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#warning to be removed

@interface Image : NSObject

- (instancetype)initWithUrlString:(NSString *)URLString;

@property(strong, readonly) NSString *URL;

@end

NS_ASSUME_NONNULL_END
