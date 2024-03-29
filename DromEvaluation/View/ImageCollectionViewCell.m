//
//  ImageCollectionViewCell.m
//  DromEvaluation
//
//  Created by Paul Cherevach on 08.03.2024.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.hidden = NO;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    [spinner startAnimating];
    self.backgroundView = spinner;
}

@end
