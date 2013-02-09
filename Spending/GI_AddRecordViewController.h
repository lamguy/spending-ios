//
//  GI_AddRecordViewController.h
//  Spending
//
//  Created by Lam Nguyen on 2/7/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "sqlite3.h"
#import "GI_Date.h"
#import "GI_Record.h"
#import "GI_CategoryCell.h"
#import "GI_NumKeyCell.h"
#import "DDPageControl.h"

@interface GI_AddRecordViewController : UITableViewController <PSTCollectionViewDataSource, PSTCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate, UITextViewDelegate>
{
    PSUICollectionView *_categoryGrid;
    PSUICollectionView *_numKeyGrid;
    
    DDPageControl *pageControl;
    
    NSArray *arrayOfCatImages;
    NSArray *arrayOfCatLabel;
    
    NSInteger catID;
    
    NSArray *arrayOfKeys;
    NSMutableArray *arrayOfRecord;
    sqlite3 *recordDB;
    NSString *dbPathString;
    long long tempAmount;
    
    NSString *locatedAt;
}
-(IBAction)cancelButtonPressed:(id)sender;
-(IBAction)doneButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextView *note;
@property (strong, nonatomic) IBOutlet UITableViewCell *noteCellView;
@property (strong, nonatomic) IBOutlet UITableViewCell *categoryGridView;
@property (strong, nonatomic) IBOutlet UIScrollView *catScroller;
@property (strong, nonatomic) IBOutlet UIView *numGridView;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;
@end
