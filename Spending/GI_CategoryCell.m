//
//  GI_CategoryCell.m
//  Spending
//
//  Created by Lam Nguyen on 2/7/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "GI_CategoryCell.h"

static UIEdgeInsets ContentInsets = { .top = 8, .left = 0, .right = 0, .bottom = 0 };
static CGFloat SubTitleLabelHeight = 24;

@implementation GI_CategoryCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *background = [[UIView alloc] init];
        background.backgroundColor = [UIColor colorWithRed:159.0/255.0 green:200.0/255.0 blue:32.0/255.0 alpha:1.000];
        self.selectedBackgroundView = background;
        
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFit;
        
        _label = [[UILabel alloc] init];
        
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_image];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat imageHeight = CGRectGetHeight(self.bounds) - ContentInsets.top - SubTitleLabelHeight - ContentInsets.bottom;
    CGFloat imageWidth = CGRectGetWidth(self.bounds) - ContentInsets.left - ContentInsets.right;
    
    _image.frame = CGRectMake(ContentInsets.left, ContentInsets.top, imageWidth, imageHeight);
    _label.frame = CGRectMake(ContentInsets.left, CGRectGetMaxY(_image.frame), imageWidth, SubTitleLabelHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
