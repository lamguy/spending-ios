//
//  GraphViewController.h
//  Spending
//
//  Created by Lam Nguyen on 2/6/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphingViewController.h"
#import "sqlite3.h"
#import "SpendDate.h"

@interface GraphViewController : UIViewController
{
    int weekNumber;
}
@property (nonatomic, retain) IBOutlet GraphingViewController *graphView;
- (id)initWithWeeknumber:(int)week;
@end
