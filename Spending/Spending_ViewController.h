//
//  Spending_ViewController.h
//  Spending
//
//  Created by Lam Nguyen on 1/21/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Record.h"

@interface Spending_ViewController : UIViewController<UIAccelerometerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    
    int currentPage;
    int selectedWeek;
    NSMutableArray *viewControllers;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *addNewSpend;
@property (strong, nonatomic) IBOutlet UIScrollView *graphScroller;
@property (strong, nonatomic) IBOutlet UITableView *recordTableView;
@property (nonatomic, retain) NSMutableArray *viewControllers;

@end
