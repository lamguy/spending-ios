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
#import "SpendDate.h"



int numberOfCatPages = 2 ;

CGSize CollectionViewCellSize = { .height = 52, .width = 52 };
CGSize NumCellSize = { .height= 44, .width=72};
NSString *CollectionViewCellIdentifier = @"RecordCell";
NSString *KeyCellIdentifier = @"KeyCell";

@interface AddSpendViewController () {
    PSUICollectionView *_gridView;
    PSUICollectionView *_numKeyGrid;
    
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

@end

@implementation AddSpendViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        catID = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDate *spendDate = [SpendDate currentDate].selectedDate;
    NSLog(@"Selected Date: %@", spendDate);
    
    
    [self createGridView];
    [self createNumBoard];
    
    
    arrayOfCatImages = [[NSArray alloc]initWithObjects:@"cat_general.png", @"cat_shopping.png", @"cat_gas.png", @"cat_restaurant.png", @"cat_computer.png", @"cat_gift.png", @"cat_babies.png", @"cat_pets.png", @"cat_personal.png", @"cat_medical.png", @"cat_housing.png", @"cat_drink.png", @"cat_transit.png", @"cat_movie.png", @"cat_movies.png", @"cat_books.png", nil];
    arrayOfCatLabel  = [[NSArray alloc]initWithObjects:@"General", @"Shopping", @"Gas", @"Restaurant", @"Computer", @"Gifts", @"Babies", @"Pets", @"Personal", @"Medical", @"Housing", @"Drink", @"Travel", @"Movies", @"Mobile", @"Books", nil];

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
    
    arrayOfKeys = [[NSArray alloc]initWithObjects:@"1", @"2", @"3", @"0", @"4", @"5", @"6", @"00", @"7", @"8", @"9", @"C", nil];
    tempAmount=0;
    
    [self.numGrid setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    
    
    //[self.note setDelegate:self];
    [self.note setReturnKeyType:UIReturnKeyDone];
    [self.note setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [self.note setTextColor:[UIColor lightGrayColor]];
    
    
    self.geoCoder = [[CLGeocoder alloc] init];
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    
    //Get user location
    [self.locationManager startUpdatingLocation];
    [self geoCodeLocated];
}


- (void)geoCodeLocated
{
    
    //Geocoding Block
    [self.geoCoder reverseGeocodeLocation: self.locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         //String to hold address
         locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         //Print the location to console
         NSLog(@"I am currently at %@",locatedAt);
         
         //Set the label text to current location
         [self.note setText:locatedAt];
         
     }];
    
    
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
    _numKeyGrid.frame = CGRectMake(10, 6, 300,150);
    
    [_numKeyGrid registerClass:[NumGrid class] forCellWithReuseIdentifier:KeyCellIdentifier];
    
    
    [self.numGrid addSubview:_numKeyGrid];
    
}



- (void)createGridView
{
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _gridView = [[PSUICollectionView alloc] initWithFrame:[self.buttonGrid bounds] collectionViewLayout:layout];
    _gridView.frame = CGRectMake(0, 0, self.view.bounds.size.width*numberOfCatPages-30, self.view.bounds.size.height);
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.allowsMultipleSelection = NO;
    [_gridView setScrollEnabled: NO];
    _gridView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [_gridView registerClass:[RecordCellController class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    // define the scroll view content size and enable paging
    [self.catScroller setDelegate:self];
	[self.catScroller setContentSize: CGSizeMake(self.view.bounds.size.width * numberOfCatPages, self.buttonGrid.bounds.size.height)] ;
    
    // programmatically add the page control
	pageControl = [[DDPageControl alloc] initWithFrame:CGRectZero] ;
    [pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [pageControl setFrame:CGRectMake(self.view.bounds.size.width/2-20,103,300,20)];
	[pageControl setNumberOfPages: numberOfCatPages] ;
	[pageControl setCurrentPage: 0] ;
	[pageControl setDefersCurrentPageDisplay: YES] ;
	[pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
	[pageControl setOnColor: [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0]] ;
	[pageControl setOffColor: [UIColor colorWithWhite: 0.7f alpha: 1.0f]] ;
	[pageControl setIndicatorDiameter: 5.0f] ;
	[pageControl setIndicatorSpace: 5.0f] ;
    
    [self.catScroller addSubview:_gridView];
	[self.buttonGrid addSubview: pageControl] ;
}

#pragma mark -
#pragma mark Collection View Data Source

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _gridView) {
        
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
        
        
        // mask icon with white color
        UIImage *maskedImage = [self newImageFromMaskImage:[UIImage imageNamed:[arrayOfCatImages objectAtIndex:indexPath.item]] inColor:[UIColor whiteColor]];
        [cell.image setImage:maskedImage];
        
        
        cell.label.textColor = [UIColor whiteColor];
        catID = [indexPath row];
        
    }
    else
    {
        
    }
    
    
    
}

- (void)collectionView:(PSUICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), indexPath);
    
    if (collectionView == _gridView) {
        
        RecordCellController *cell = (RecordCellController *)[collectionView cellForItemAtIndexPath:indexPath];
        
        
        // get the original icon back
        [cell.image setImage:[UIImage imageNamed:[arrayOfCatImages objectAtIndex:indexPath.item]]];
        
        cell.label.textColor = [UIColor lightGrayColor];
    }
    else
    {
        
    }
    
    
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    
	CGFloat pageWidth = self.catScroller.bounds.size.width;
    
    //[self.catScroller setContentOffset: CGPointMake(self.catScroller.bounds.size.width * pageControl.currentPage, self.catScroller.contentOffset.y) animated: YES] ;
    
    NSLog(@"%f", self.catScroller.bounds.size.width);
    float fractionalPage = self.catScroller.contentOffset.x / pageWidth ;
	NSInteger nearestNumber = lround(fractionalPage) ;
	
	if (pageControl.currentPage != nearestNumber)
	{
		pageControl.currentPage = nearestNumber ;
		
		// if we are dragging, we want to update the page control directly during the drag
		if (self.catScroller.dragging)
			[pageControl updateCurrentPageDisplay] ;
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
    self.catScroller.frame = CGRectMake(10,10,self.view.bounds.size.width * pageControl.currentPage,self.catScroller.bounds.size.height);
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
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString=[dateFormat stringFromDate:[SpendDate currentDate].selectedDate];
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO SPENDS(CAT_ID, NAME, NOTE, ADDRESS, AMOUNT, DATE_ADDED) values ('%d', '%s', '%s', '%s', '%lld', '%s')", catID, [self.name.text UTF8String], [self.note.text UTF8String], [locatedAt UTF8String], [cleanAmount longLongValue], [dateString UTF8String]];
        
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
        
        NSLog(@"Error: %s", error);
        
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTableNotification" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGraphNotification" object:self];
        }];
    }
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
        
        if([cell.key.text isEqualToString:[NSString stringWithFormat:@"00" ]])
        {
            NSLog(@"tapped 00");
            tempAmount = tempAmount*100+[cell.key.text longLongValue];
        }
        else if([cell.key.text isEqualToString:[NSString stringWithFormat:@"C" ]])
        {
            tempAmount = 0.00;
            NSLog(@"tapped C");
        }
        else
        {
            tempAmount = tempAmount*10+[cell.key.text longLongValue];
        }
        self.amount.text = [NSString stringWithFormat:@"%.02f", tempAmount/100.00];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [cell setSelected:NO];
            [cell.key setTextColor:[UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0]];
        });
    }
}
         
         
// stackoverflow.com/questions/5423210/how-do-i-change-a-partially-transparent-images-color-in-ios
// Usage: UIImage *mask = [self newImageFromMaskImage:<#(UIImage *)#> inColor:<#(UIColor *)#>];

-(UIImage *) newImageFromMaskImage:(UIImage *)mask inColor:(UIColor *) color {
    CGImageRef maskImage = mask.CGImage;
    CGFloat width = mask.size.width;
    CGFloat height = mask.size.height;
    CGRect bounds = CGRectMake(0,0,width,height);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClipToMask(bitmapContext, bounds, maskImage);
    CGContextSetFillColorWithColor(bitmapContext, color.CGColor);
    CGContextFillRect(bitmapContext, bounds);

    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);

    UIImage *result = [UIImage imageWithCGImage:mainViewContentBitmapContext];
    return result;
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
