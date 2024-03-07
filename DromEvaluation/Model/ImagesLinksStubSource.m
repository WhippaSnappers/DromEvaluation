//
//  ImagesSource.m
//  DromEvaluation
//
//  Created by Paul Cherevach on 05.03.2024.
//

#import "ImagesLinksStubSource.h"

@implementation ImagesLinksStubSource

- (instancetype) init {
    self = [super init];
    if (self) {
        _images = @[
            @"https://fastly.picsum.photos/id/184/800/800.jpg?hmac=lmC8WI1eOGRKHRp2-ljqfQZcfb5306DsbFJcRBuSTwY",
            @"https://fastly.picsum.photos/id/417/800/800.jpg?hmac=N5aD-9FF1xFGj7_HepZonu9Ap_1ihcKUGL797VgCvO4",
            @"https://fastly.picsum.photos/id/5/800/800.jpg?hmac=pkRT69hNPc8vc44_7ane1t0WgN5hH1eoYWzpkN-MTXs",
            @"https://fastly.picsum.photos/id/320/800/800.jpg?hmac=ZybisayRFd7o9p0eNJbXO3ZdkXtQmkG5TqtzCVHBWNY",
            @"https://fastly.picsum.photos/id/967/800/800.jpg?hmac=HK8QLj6x-VucgPZfebivVwNaIw93flmHm6odUVbZupo",
            @"https://fastly.picsum.photos/id/543/800/800.jpg?hmac=VU5oYbeajflZMTxXjusSwu1lZsjdYI4lrfNTjTyz3pQ"
        ];
    }
    return self;
}

@end
