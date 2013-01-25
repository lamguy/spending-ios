//
//  AddSpendViewController.m
//  Spending
//
//  Created by Lam Nguyen on 1/21/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "AddSpendViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "RecordCellController.h"
#import "sqlite3.h"
#import "Record.h"

static const NSUInteger kNumSection = 40;

CGSize CollectionViewCellSize = { .height = 52, .width = 52 };
NSString *CollectionViewCellIdentifier = @"RecordCell";

@interface AddSpendViewController () {
    PSUICollectionView *_gridView;
    
    NSArray *arrayOfCatImages;
    NSArray *arrayOfCatLabel;
    
    NSArray *arrayOfKeys;
    NSMutableArray *arrayOfRecord;
    sqlite3 *recordDB;
    NSString *dbPathString;
}

@end

@implementation AddSpendViewController

@synthesize note = _note;
@synthesize name;
@synthesize buttonGrid;
@synthesize keyGrid;
@synthesize star;
@synthesize list;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createGridView];
    
    
    arrayOfCatImages = [[NSArray alloc]initWithObjects:@"cat_general.png", @"cat_shopping.png", @"cat_gas.png", @"cat_restaurant.png", @"cat_computer.png", @"cat_housing", @"cat_drink", @"cat_transit", @"cat_movie", @"cat_movies", nil];
    arrayOfCatLabel  = [[NSArray alloc]initWithObjects:@"General", @"Shopping", @"Gas", @"Restaurant", @"Computer", @"Housing", @"Drink", @"Travel", @"Movies", @"Mobile", nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    // For selecting cell.
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    UIImage *favImageOff = [UIImage imageNamed:@"star-off.png"];
    UIImage *favImageOn = [UIImage imageNamed:@"star-on.png"];
    [self.star setImage:favImageOff forState:UIControlStateNormal];
    [self.star setImage:favImageOn forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.star setBackgroundColor:[UIColor clearColor]];
    
    
    [self.name setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    
    
    
    /*
    UIImage* WhiteButtonImage = [[UIImage imageNamed:@"whiteButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [self.list setBackgroundImage:WhiteButtonImage forState:UIControlStateNormal];
     */
    
    arrayOfKeys = [[NSArray alloc]initWithObjects:@"1", @"2", @"3", @"0", @"4", @"5", @"6", @".", @"7", @"8", @"9", @"C", nil];
    
    [self.keyGrid setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    
    
    [self.note setDelegate:self];
    [self.note setReturnKeyType:UIReturnKeyDone];
    [self.note setText:@"Enter some note here, maybe!"];
    [self.note setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [self.note setTextColor:[UIColor lightGrayColor]];
}



- (void)createGridView {
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _gridView = [[PSUICollectionView alloc] initWithFrame:[self.buttonGrid bounds] collectionViewLayout:layout];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.allowsMultipleSelection = NO;
    _gridView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [_gridView registerClass:[RecordCellController class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    [self.buttonGrid addSubview:_gridView];
}

#pragma mark -
#pragma mark Collection View Data Source

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {    
    RecordCellController *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.0]];
    cell.layer.cornerRadius = 4; // rounded corners
    [cell.image setImage:[UIImage imageNamed:[arrayOfCatImages objectAtIndex:indexPath.item]]];
    
    [cell.label setText:[arrayOfCatLabel objectAtIndex:indexPath.item]];
    [cell.label setFont:[UIFont fontWithName:@"HelveticaNeue" size:9]];
    [cell.label setTextColor:[UIColor lightGrayColor]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CollectionViewCellSize;
}

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [arrayOfCatLabel count];
}

#pragma mark -
#pragma mark Collection View Delegate

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), indexPath);
}

- (void)collectionView:(PSUICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), indexPath);
}

#pragma mark - IBActions

-(void)starPressed:(id)sender {
    UIButton* button = (UIButton*)sender;
    button.selected = !button.selected;
}

// Jimmy Theis - https://www.youtube.com/watch?v=2p8Gctq62oU
-(void)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)doneButtonPressed:(id)sender {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    dbPathString = [docPath stringByAppendingPathComponent:@"spending.db"];
    
    char *error;
    
    //create db here
    if(sqlite3_open([dbPathString UTF8String], &recordDB)==SQLITE_OK)
    {
        NSLog(@"DB opened for inserting task");
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO SPENDS(CAT_ID, NAME, NOTE) values ('%d', '%s', '%s')", 1, [self.name.text UTF8String], [self.note.text UTF8String]];
        
        const char *insert_spending_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(recordDB, insert_spending_stmt, NULL, NULL, &error)==SQLITE_OK) {
            NSLog(@"Spend record added");
            
            Record *record = [[Record alloc] init];
            
            [record setName:self.name.text];
            [record setNote:self.note.text];
        }
        
        if(sqlite3_close(recordDB)==SQLITE_OK)
        {
            NSLog(@"DB closed after inserting");
        }
    }
    
        
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark TextView Delegate methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.note.textColor == [UIColor lightGrayColor]) {
        self.note.text = @"";
        self.note.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.note.text.length == 0){
        self.note.textColor = [UIColor lightGrayColor];
        self.note.text = @"Enter some note here, maybe!";
        [self.note resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self.note resignFirstResponder];
        if(self.note.text.length == 0){
            self.note.textColor = [UIColor lightGrayColor];
            self.note.text = @"Enter some note here, maybe!";
            [self.note resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

@end
