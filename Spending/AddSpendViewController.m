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
#import "NumGrid.h"
#import "sqlite3.h"
#import "Record.h"

CGSize CollectionViewCellSize = { .height = 52, .width = 52 };
CGSize NumCellSize = { .height= 44, .width=72};
NSString *CollectionViewCellIdentifier = @"RecordCell";
NSString *KeyCellIdentifier = @"KeyCell";

@interface AddSpendViewController () {
    PSUICollectionView *_gridView;
    PSUICollectionView *_numKeyGrid;
    
    NSArray *arrayOfCatImages;
    NSArray *arrayOfCatLabel;
    
    NSArray *arrayOfKeys;
    NSMutableArray *arrayOfRecord;
    sqlite3 *recordDB;
    NSString *dbPathString;
    long long tempAmount;
}

@end

@implementation AddSpendViewController

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
    [self createNumBoard];
    
    
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
    tempAmount=0;
    
    [self.numGrid setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    
    
    [self.note setDelegate:self];
    [self.note setReturnKeyType:UIReturnKeyDone];
    [self.note setText:@"Enter some note here, maybe!"];
    [self.note setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [self.note setTextColor:[UIColor lightGrayColor]];
}

- (void)createNumBoard
{
    
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _numKeyGrid = [[PSUICollectionView alloc] initWithFrame:[self.numGrid bounds] collectionViewLayout:layout];
    _numKeyGrid.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _numKeyGrid.delegate = self;
    _numKeyGrid.dataSource = self;
    _numKeyGrid.allowsSelection = NO;
    _numKeyGrid.allowsMultipleSelection = NO;
    _numKeyGrid.backgroundColor = [UIColor clearColor];
    _numKeyGrid.frame = CGRectMake(10, 15, 300,150);
    
    [_numKeyGrid registerClass:[NumGrid class] forCellWithReuseIdentifier:KeyCellIdentifier];
    
    
    [self.numGrid addSubview:_numKeyGrid];
    
}



- (void)createGridView
{
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
    
    if (collectionView == _gridView) {
        NSLog(@"cat cell called");
        
        RecordCellController *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
        
        [cell setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.0]];
        cell.layer.cornerRadius = 4; // rounded corners
        [cell.image setImage:[UIImage imageNamed:[arrayOfCatImages objectAtIndex:indexPath.item]]];
        
        [cell.label setText:[arrayOfCatLabel objectAtIndex:indexPath.item]];
        [cell.label setFont:[UIFont fontWithName:@"HelveticaNeue" size:9]];
        [cell.label setTextColor:[UIColor lightGrayColor]];
        return cell;
    }
    else if (collectionView == _numKeyGrid)
    {
        NSLog(@"num cell called");
        NumGrid *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KeyCellIdentifier forIndexPath:indexPath];
        [cell.key setText:[arrayOfKeys objectAtIndex:indexPath.item]];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numTapped:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [cell addGestureRecognizer:singleTap];
        
        return cell;
    }
    
    return nil;
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _gridView)
    {
        return CollectionViewCellSize;
    }
    else
    {
        return NumCellSize;
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _gridView) {
        return [arrayOfCatLabel count];
    }
    else
    {
        return [arrayOfKeys count];
    }
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == _gridView)
    {
        return 10;
    }
    else
    {
        return 4;
    }
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == _gridView)
    {
        return 10;
    }
    else
    {
        return 5;
    }
}

#pragma mark -
#pragma mark Collection View Delegate

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), indexPath);
    
    if (collectionView == _gridView) {
        
        RecordCellController *cell = (RecordCellController *)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell.label.textColor = [UIColor whiteColor];
    }
    else
    {
        
    }
    
    
    
}

- (void)collectionView:(PSUICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), indexPath);
    
    if (collectionView == _gridView) {
        
        RecordCellController *cell = (RecordCellController *)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell.label.textColor = [UIColor lightGrayColor];
    }
    else
    {
        
    }
    
    
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
        
        NSString *cleanAmount = [self.amount.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO SPENDS(CAT_ID, NAME, NOTE, AMOUNT) values ('%d', '%s', '%s', '%lld')", 1, [self.name.text UTF8String], [self.note.text UTF8String], [cleanAmount longLongValue]];
        
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
    
    NSLog(@"Error: %s", error);
        
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)numTapped:(UITapGestureRecognizer *)tap
{
    if (UIGestureRecognizerStateEnded == tap.state) {
        NSLog(@"tapped");
        
        NumGrid *cell = (NumGrid *)tap.view;
        [cell setSelected:YES];
        [cell.key setTextColor:[UIColor whiteColor]];
        
        tempAmount = tempAmount*10+[cell.key.text longLongValue];
        self.amount.text = [NSString stringWithFormat:@"%.02f", tempAmount/100.00];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [cell setSelected:NO];
            [cell.key setTextColor:[UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0]];
        });
    }
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
