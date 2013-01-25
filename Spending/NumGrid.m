//
//  NumGrid.m
//  Spending
//
//  Created by Lam Nguyen on 1/25/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "NumGrid.h"
static UIEdgeInsets ContentInsets = { .top = 8, .left = 0, .right = 0, .bottom = 0 };
static CGFloat SubTitleLabelHeight = 24;

@implementation NumGrid

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *background = [[UIView alloc] init];
        background.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.000];
        
        [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        self.selectedBackgroundView = background;
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 2; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.2;
        
        _key = [[UIButton alloc] init];
        [[_key layer] setCornerRadius:4];
        _key.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:31];
        _key.titleLabel.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:_key];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat imageHeight = CGRectGetHeight(self.bounds) - ContentInsets.top - SubTitleLabelHeight - ContentInsets.bottom;
    CGFloat imageWidth = CGRectGetWidth(self.bounds) - ContentInsets.left - ContentInsets.right;
    
    //_image.frame = CGRectMake(ContentInsets.left, ContentInsets.top, imageWidth, imageHeight);
    //_label.frame = CGRectMake(ContentInsets.left, CGRectGetMaxY(_image.frame), imageWidth, SubTitleLabelHeight);
}

@end
