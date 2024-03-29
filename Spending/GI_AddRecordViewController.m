//
//  GI_AddRecordViewController.m
//  Spending
//
//  Created by Lam Nguyen on 2/7/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "GI_AddRecordViewController.h"

int numberOfCatPages = 2 ;
CGSize CollectionViewCellSize = { .height = 52, .width = 52 };
CGSize NumCellSize = { .height= 44, .width=72};
NSString *CollectionViewCellIdentifier = @"CategoryCell";
NSString *KeyCellIdentifier = @"KeyCell";

@interface GI_AddRecordViewController ()

@end

@implementation GI_AddRecordViewController

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
    
    NSDate *spendDate = [GI_Date date].selectedDate;
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
    
    //UIImage *favImageOff = [UIImage imageNamed:@"star-off.png"];
    //UIImage *favImageOn = [UIImage imageNamed:@"star-on.png"];
    
    
    [self.name setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    
    
    
    /*
     UIImage* WhiteButtonImage = [[UIImage imageNamed:@"whiteButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
     [self.list setBackgroundImage:WhiteButtonImage forState:UIControlStateNormal];
     */
    
    arrayOfKeys = [[NSArray alloc]initWithObjects:@"1", @"2", @"3", @"0", @"4", @"5", @"6", @"del", @"7", @"8", @"9", @"C", nil];
    tempAmount=0;
    
    [self.numGridView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    _numKeyGrid = [[PSUICollectionView alloc] initWithFrame:[self.numGridView bounds] collectionViewLayout:layout];
    _numKeyGrid.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _numKeyGrid.delegate = self;
    _numKeyGrid.dataSource = self;
    _numKeyGrid.allowsSelection = NO;
    _numKeyGrid.allowsMultipleSelection = NO;
    _numKeyGrid.backgroundColor = [UIColor clearColor];
    _numKeyGrid.frame = CGRectMake(10, 6, 300,150);
    
    [_numKeyGrid registerClass:[GI_NumKeyCell class] forCellWithReuseIdentifier:KeyCellIdentifier];
    
    
    [self.numGridView addSubview:_numKeyGrid];
    
}



- (void)createGridView
{
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _categoryGrid = [[PSUICollectionView alloc] initWithFrame:[self.categoryGridView bounds] collectionViewLayout:layout];
    _categoryGrid.frame = CGRectMake(0, 5, 300*numberOfCatPages + 10, 114);
    _categoryGrid.delegate = self;
    _categoryGrid.dataSource = self;
    _categoryGrid.allowsMultipleSelection = NO;
    [_categoryGrid setScrollEnabled: NO];
    _categoryGrid.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [_categoryGrid registerClass:[GI_CategoryCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    // define the scroll view content size and enable paging
    [self.catScroller setDelegate:self];
	[self.catScroller setContentSize: CGSizeMake(300*numberOfCatPages + 10, 114)] ;
    
    // programmatically add the page control
	pageControl = [[DDPageControl alloc] initWithFrame:CGRectZero] ;
    [pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [pageControl setFrame:CGRectMake(self.view.bounds.size.width/2-20,113,300,20)];
	[pageControl setNumberOfPages: numberOfCatPages] ;
	[pageControl setCurrentPage: 0] ;
	[pageControl setDefersCurrentPageDisplay: YES] ;
	[pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
	[pageControl setOnColor: [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0]] ;
	[pageControl setOffColor: [UIColor colorWithWhite: 0.7f alpha: 1.0f]] ;
	[pageControl setIndicatorDiameter: 5.0f] ;
	[pageControl setIndicatorSpace: 5.0f] ;
    
    [self.catScroller addSubview:_categoryGrid];
	[self.categoryGridView addSubview: pageControl] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 35.0f;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    switch (indexPath.row) {
        case 0:
            height=43;
            break;
            
        case 1:
            height=35;
            break;
            
        case 2:
            if (screenSize.height > 480.0f) {
                height=140;
            }
            else
            {
                height=55;
            }
            break;
        case 3:
            height=145;
            break;
            
        default:
            break;
    }
    
    return height;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark -
#pragma mark Collection View Data Source

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == _categoryGrid) {
        
        GI_CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
        
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
        GI_NumKeyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KeyCellIdentifier forIndexPath:indexPath];
        
        if ([[arrayOfKeys objectAtIndex:indexPath.item] isEqualToString:@"del"]) {
            UIImageView *delImage = [[UIImageView alloc] init];
            [delImage setImage:[UIImage imageNamed:@"delete.png"]];
            CGFloat imageWidth = 28.0;
            CGFloat imageHeight = 20.0;
            delImage.frame = CGRectMake(20, 12, imageWidth, imageHeight);
            [cell.contentView addSubview:delImage];
            [cell.key setText:@""];
        }
        else
        {
            [cell.key setText:[arrayOfKeys objectAtIndex:indexPath.item]];
        }
        
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
    
    if (collectionView == _categoryGrid)
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
    if (collectionView == _categoryGrid) {
        return [arrayOfCatLabel count];
    }
    else
    {
        return [arrayOfKeys count];
    }
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == _categoryGrid)
    {
        return 10;
    }
    else
    {
        return 4;
    }
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == _categoryGrid)
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
    
    if (collectionView == _categoryGrid) {
        
        GI_CategoryCell *cell = (GI_CategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        
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
    
    if (collectionView == _categoryGrid) {
        
        GI_CategoryCell *cell = (GI_CategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.05];
    
	CGFloat pageWidth = self.catScroller.bounds.size.width;
    float fractionalPage = self.catScroller.contentOffset.x / pageWidth ;
	NSInteger nearestNumber = lround(fractionalPage) ;
	
	if (pageControl.currentPage != nearestNumber)
	{
		pageControl.currentPage = nearestNumber ;
		
		// if we are dragging, we want to update the page control directly during the drag
		if (self.catScroller.dragging)
        {
			[pageControl updateCurrentPageDisplay];
        }
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
    //http://stackoverflow.com/questions/993280/how-to-detect-when-a-uiscrollview-has-finished-scrolling
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(pageControl.currentPage==1)
    {
        // Setting offset with animation of UIView
        [UIView animateWithDuration:0.05
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^
         {
             [self.catScroller setContentOffset:CGPointMake(300 * pageControl.currentPage + 10, 0)];
         }
                         completion:^(BOOL finished){}];
    }
}

#pragma mark - IBActions

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
        NSString *dateString=[dateFormat stringFromDate:[GI_Date date].selectedDate];
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO SPENDS(CAT_ID, NAME, NOTE, ADDRESS, AMOUNT, DATE_ADDED) values ('%d', '%s', '%s', '%s', '%lld', '%s')", catID, [self.name.text UTF8String], [self.note.text UTF8String], [locatedAt UTF8String], [cleanAmount longLongValue], [dateString UTF8String]];
        
        const char *insert_spending_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(recordDB, insert_spending_stmt, NULL, NULL, &error)==SQLITE_OK) {
            NSLog(@"Spend record added");
            
            GI_Record *record = [[GI_Record alloc] init];
            
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataNotification" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGraphNotification" object:self];
        }];
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

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)numTapped:(UITapGestureRecognizer *)tap
{
    if (UIGestureRecognizerStateEnded == tap.state) {
        
        GI_NumKeyCell *cell = (GI_NumKeyCell *)tap.view;
        [cell setSelected:YES];
        [cell.key setTextColor:[UIColor whiteColor]];
        
        if([cell.key.text isEqualToString:[NSString stringWithFormat:@"" ]])
        {
            tempAmount = tempAmount/10;
        }
        else if([cell.key.text isEqualToString:[NSString stringWithFormat:@"C" ]])
        {
            tempAmount = 0.00;
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

@end
