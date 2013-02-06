//
//  GraphViewController.h
//  Spending
//
//  Created by Lam Nguyen on 2/6/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "SpendDate.h"
#define kGraphHeight 56
#define kDefaultGraphWidth 300
#define kOffsetX 20
#define kStepX 46
#define kGraphBottom 89
#define kGraphTop 0
#define kStepY 20
#define kOffsetY 15
#define kCircleRadius 3

#define kBarTop 10
#define kBarWidth 40
#define kNumberOfBars 7

@interface GraphViewController : UIViewController
{
    int weekNumber;
    UILabel *titleA;
}
@property (nonatomic, retain) IBOutlet UILabel *titleA;
- (id)initWithWeeknumber:(int)week;
@end
