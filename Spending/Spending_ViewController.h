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

@interface Spending_ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *addNewSpend;
@property (strong, nonatomic) IBOutlet UIScrollView *graphScroller;
@property (weak, nonatomic) IBOutlet UITableView *recordTableView;

@end
