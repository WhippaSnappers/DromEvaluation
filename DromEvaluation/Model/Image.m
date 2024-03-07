//
//  Image.m
//  DromEvaluation
//
//  Created by Paul Cherevach on 05.03.2024.
//

#import "Image.h"

@implementation Image

- (instancetype)initWithUrlString:(NSString *)URLString {
    self = [super init];
    if (self) _URL = URLString;
    return self;
}

@end
