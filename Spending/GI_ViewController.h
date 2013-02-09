//
//  GI_ViewController.h
//  Spending
//
//  Created by Lam Nguyen on 2/7/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "GI_GraphViewController.h"
#import "GI_Record.h"
#import "GI_RecordCellView.h"

@interface GI_ViewController : UIViewController<UIAccelerometerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    int currentPage;
    int selectedWeek;
    int week;
    NSMutableArray *viewControllers;
    
    sqlite3 *recordDB;
    NSString *dbPathString;
    
    
    NSArray *arrayOfCatImages;
    NSMutableArray *arrayOfRecord;
    NSMutableArray *filterArrayOfRecord;
    NSMutableArray *reversed_arrayOfRecord;
}

@property (strong, nonatomic) IBOutlet UIScrollView *graphScroller;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (strong, nonatomic) IBOutlet UITableView *recordTableView;
@property (strong, nonatomic) IBOutlet UIButton *addNewSpendButton;
@end
