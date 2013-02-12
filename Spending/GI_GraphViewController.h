//
//  GI_GraphViewController.h
//  Spending
//
//  Created by Lam Nguyen on 2/7/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GI_GraphView.h"
#import "GI_Date.h"

@interface GI_GraphViewController : UIViewController
{
    sqlite3 *recordDB;
    NSString *dbPathString;
    NSArray *weekdate;
}

@property (assign) NSInteger week;
@property (nonatomic, retain) IBOutlet GI_GraphView *graphView;
- (id)initWithWeeknumber:(int)week;

@end
