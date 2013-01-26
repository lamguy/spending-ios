//
//  NumGrid.m
//  Spending
//
//  Created by Lam Nguyen on 1/25/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "NumGrid.h"
static UIEdgeInsets ContentInsets = { .top = 6, .left = 26, .right = 0, .bottom = 0 };
static CGFloat SubTitleLabelHeight = 32;

@implementation NumGrid

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *background = [[UIView alloc] init];
        background.backgroundColor = [UIColor blackColor];
        
        [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        self.selectedBackgroundView = background;
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 2;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.2;
        
        _key = [[UILabel alloc] init];
        _key.backgroundColor = [UIColor clearColor];
        [_key setNumberOfLines:1];
        [_key sizeToFit];
        [_key setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30]];
        [_key setTextColor:[UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0]];
        
        [self.contentView addSubview:_key];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat imageWidth = CGRectGetWidth(self.bounds) - ContentInsets.left - ContentInsets.right;
    _key.frame = CGRectMake(ContentInsets.left, ContentInsets.top, imageWidth, SubTitleLabelHeight);
}

@end
