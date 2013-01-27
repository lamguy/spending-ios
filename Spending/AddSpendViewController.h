//
//  AddSpendViewController.h
//  Spending
//
//  Created by Lam Nguyen on 1/21/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "DDPageControl.h"

@interface AddSpendViewController : UITableViewController <PSTCollectionViewDataSource, PSTCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    DDPageControl *pageControl;
}

-(IBAction)cancelButtonPressed:(id)sender;
-(IBAction)doneButtonPressed:(id)sender;
-(IBAction)starPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextView *note;
@property (strong, nonatomic) IBOutlet UIView *buttonGrid;
@property (strong, nonatomic) IBOutlet UIView *numGrid;
@property (weak, nonatomic) IBOutlet UIButton *star;
@property (strong, nonatomic) IBOutlet UIButton *list;
@end
