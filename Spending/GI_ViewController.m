//
//  GI_ViewController.m
//  Spending
//
//  Created by Lam Nguyen on 2/7/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "GI_ViewController.h"

@interface GI_ViewController ()

@end

@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end

@implementation GI_ViewController
@synthesize graphScroller, viewControllers, recordTableView;
static NSUInteger kNumberOfPages = 3;

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self)
    {
        NSLog(@"Initializing Spending ...");
        //Initialize some data arrays
        arrayOfCatImages = [[NSArray alloc]initWithObjects:@"cat_general.png", @"cat_shopping.png", @"cat_gas.png", @"cat_restaurant.png", @"cat_computer.png", @"cat_gift.png", @"cat_babies.png", @"cat_pets.png", @"cat_personal.png", @"cat_medical.png", @"cat_housing.png", @"cat_drink.png", @"cat_transit.png", @"cat_movie.png", @"cat_movies.png", @"cat_books.png", nil];
        
        
    
        //init array of all the records need to shown up on tableview
        arrayOfWeeklyRecord = [[NSMutableArray alloc]init];
        arrayOfRecord = [[NSMutableArray alloc]init];
        filterArrayOfRecord = [NSMutableArray arrayWithCapacity:[arrayOfWeeklyRecord count]];
    
    
        //Init database objects
    
        path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docPath = [path objectAtIndex:0];
        dbPathString = [docPath stringByAppendingPathComponent:@"spending.db"];
        fileManager = [NSFileManager defaultManager];
        
        NSLog(@"Finished Initializing");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSLog(@"Spending view has been loaded");
    
    //Set new background for regular buttons
    UIImage* RegButtonBlue = [[UIImage imageNamed:@"regular_button_blue.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 6, 3, 6) resizingMode:UIImageResizingModeStretch];
    self.addNewSpendButton.frame = CGRectMake(0.0, 0.0, 300, 24);
    [self.addNewSpendButton setBackgroundImage:RegButtonBlue forState:UIControlStateNormal];
    self.addNewSpendButton.titleLabel.shadowColor = [UIColor colorWithRed:(42.0/255.0) green:(123.0/255.0) blue:(190.0/255.0) alpha:1.0];
    self.addNewSpendButton.titleLabel.shadowOffset = CGSizeMake(0, -1.0);
    
    //begin to create database if not existed and load data records
    [self createOrOpenDB];
    [self readDataFromDatabase];
    [self.recordTableView reloadData];
    
    graphScroller.frame = CGRectMake(10, 0, 300, 80);
    graphScroller.pagingEnabled = YES;
    graphScroller.contentSize = CGSizeMake(graphScroller.frame.size.width*3, graphScroller.frame.size.height);
    graphScroller.showsHorizontalScrollIndicator = YES;
    graphScroller.showsVerticalScrollIndicator = YES;
    graphScroller.scrollsToTop = NO;
    graphScroller.delegate = self;
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages+1; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    viewControllers = controllers;
    
    [self loadScrollViewWithWeekNumber:week-1 appendToPage:0];
    [self loadScrollViewWithWeekNumber:week appendToPage:1];
    [self loadScrollViewWithWeekNumber:week+1 appendToPage:2];
    
    CGRect frame = graphScroller.frame;
    frame.origin.x = frame.size.width * 1;
    frame.origin.y = 0;
    [self moveScrollViewTo:1 animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"updateTableNotification" object:nil];
}

-(void)createOrOpenDB
{
    char *error;
    if(![fileManager fileExistsAtPath:dbPathString])
    {
        
        //create db here
        if(sqlite3_open([dbPathString UTF8String], &recordDB)==SQLITE_OK)
        {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS SPENDS(ID INTEGER PRIMARY KEY AUTOINCREMENT, CAT_ID INTEGER, NAME TEXT, NOTE TEXT, ADDRESS TEXT, AMOUNT INETEGER, DATE_ADDED TEXT)";
            sqlite3_exec(recordDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(recordDB);
        }
    }
}

-(void)readDataFromDatabase
{
    
    sqlite3_stmt *query_stmt;
    
    NSDate *date = [GI_Date date].selectedDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSWeekCalendarUnit fromDate:date];
    week = [components week];
    
    selectedWeek = week;
    weekdate = [self allDatesInWeek:week];
    
    if (sqlite3_open([dbPathString UTF8String], &recordDB)==SQLITE_OK)
    {
        [arrayOfWeeklyRecord removeAllObjects];
        [arrayOfRecord removeAllObjects];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString=[dateFormat stringFromDate:date];
        fromDate = [dateFormat stringFromDate:weekdate[0]];
        toDate = [dateFormat stringFromDate:weekdate[6]];
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM SPENDS WHERE DATE_ADDED BETWEEN ? AND ?"];
        
        if (sqlite3_prepare(recordDB, [querySQL UTF8String], -1, &query_stmt, NULL)==SQLITE_OK) {
            sqlite3_bind_text(query_stmt, 1, [fromDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(query_stmt, 2, [toDate UTF8String], -1, SQLITE_TRANSIENT);
            while (sqlite3_step(query_stmt)==SQLITE_ROW) {
                NSInteger ID=sqlite3_column_int(query_stmt, 0);
                NSInteger cat_ID=sqlite3_column_int(query_stmt, 1);
                NSString *name=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(query_stmt, 2)];
                NSString *note=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(query_stmt, 3)];
                NSString *amount=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(query_stmt, 5)];
                NSString *date_added_string=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(query_stmt, 6)];
                NSDate *date_added= [dateFormat dateFromString:date_added_string];
                
                GI_Record *record = [[GI_Record alloc]init];
                
                [record setID:ID];
                [record setCat_id:cat_ID];
                [record setName:name];
                [record setNote:note];
                [record setAmount:[amount intValue]];
                [record setDate_added:date_added];
                
                [arrayOfWeeklyRecord addObject:record];
                
            }
            
            sqlite3_finalize(query_stmt);
            sqlite3_close(recordDB);
            
            //Now we need to reverse the array of our records for better UX
            [arrayOfWeeklyRecord reverse];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[GI_Date date].selectedDate];
            
            predicate = [NSPredicate predicateWithFormat:@"SELF.date_added = %@", [gregorian dateFromComponents:components]];
            arrayOfRecord = [NSMutableArray arrayWithArray:[arrayOfWeeklyRecord filteredArrayUsingPredicate:predicate]];
        }
    }
}

-(void)loadScrollViewWithWeekNumber:(int)weekNumber appendToPage:(int)page
{
    // replace the placeholder if necessary
    GI_GraphViewController *graph = [[GI_GraphViewController alloc] initWithWeeknumber:weekNumber];
    
    CGRect frame = graphScroller.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    graph.view.frame = frame;
    
    [graphScroller addSubview:graph.view];
}

-(void) moveScrollViewTo:(int)page animated:(BOOL)animated {
    
    // update the scroll view to the appropriate page
    CGRect frame = graphScroller.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [graphScroller scrollRectToVisible:frame animated:animated];
    
}


- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated {
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = graphScroller.frame.size.width;
    int page = floor((graphScroller.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    currentPage = page;
    
    [[graphScroller subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // load the visible page and the page on either side of it
    //(to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithWeekNumber:selectedWeek-1 appendToPage:0];
    [self loadScrollViewWithWeekNumber:selectedWeek appendToPage:1];
    [self loadScrollViewWithWeekNumber:selectedWeek+1 appendToPage:2];
    
    NSLog(@"Selected week: %d", selectedWeek);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    
    switch (currentPage) {
        case 0:
            selectedWeek -=1;
            break;
        case 2:
            selectedWeek +=1;
            break;
        default:
            break;
    }
    
    [self moveScrollViewTo:1 animated:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filterArrayOfRecord count];
    } else {
        return [arrayOfRecord count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    headerView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    CALayer *botLine = [CALayer layer];
    botLine.frame = CGRectMake(0, 25, 320, 1);
    botLine.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    [headerView.layer addSublayer:botLine];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMMM d, YYYY"];
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 7, tableView.bounds.size.width, 12);
    label.textColor = [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"Bitter-Regular" size:10];
    label.backgroundColor = [UIColor clearColor];
    label.layer.shadowOpacity = 1.0;
    label.layer.shadowRadius = 0.0;
    label.layer.shadowColor = [UIColor whiteColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    label.textAlignment = NSTextAlignmentCenter;
    NSString *sectionTitle = [dateFormat stringFromDate:[GI_Date date].selectedDate];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        sectionTitle = [NSString stringWithFormat:@"%s  \u2014  %s", [fromDate UTF8String], [toDate UTF8String]];
    }
    
    NSString *uppercaseSectionTitle = [sectionTitle uppercaseString];
    label.text = uppercaseSectionTitle;
    
    [headerView addSubview:label];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"RecordCell";
    GI_RecordCellView *cell = [recordTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    GI_Record *aRecord;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        aRecord = [filterArrayOfRecord objectAtIndex:indexPath.row];
    }
    else
    {
        aRecord = [arrayOfRecord objectAtIndex:indexPath.row];
    }
    
    cell.recordName.text = aRecord.name;
    cell.recordNote.text = aRecord.note;
    
    UIImage *originalCatImage = [UIImage imageNamed:arrayOfCatImages[aRecord.cat_id]];
    cell.recordCat.image = originalCatImage;
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc]init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    // format currency displaying on talbeview
    double amountInFloat = aRecord.amount/100.00;
    cell.recordAmount.text = [NSString stringWithFormat:@"$%.02f", amountInFloat];
    
    return cell;
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        GI_Record *record = [arrayOfRecord objectAtIndex:indexPath.row];
        [self deleteRecord:[NSString stringWithFormat:@"DELETE FROM SPENDS WHERE ID=%d", record.ID]];
        
        [arrayOfRecord removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        NSLog(@"record id %d", record.ID);
    }
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [filterArrayOfRecord removeAllObjects];
    // Filter the array using NSPredicate
    predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@ OR SELF.note contains[c] %@",searchText, searchText];
    filterArrayOfRecord = [NSMutableArray arrayWithArray:[arrayOfWeeklyRecord filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


-(void)deleteRecord:(NSString *)deleteQuery
{
    if(sqlite3_open([dbPathString UTF8String], &recordDB)==SQLITE_OK)
    {
        char *error;
        if (sqlite3_exec(recordDB, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK) {
            NSLog(@"Record deleted");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataNotification" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateGraphNotification" object:self];
        }
        sqlite3_close(recordDB);
        NSLog(@"%s", error);
    }
    
}

-(void)reloadTableView:(NSNotification *) notification
{
    NSLog(@"Reload Table notification recieved:%@", notification.userInfo);
    [self readDataFromDatabase];
    [self.recordTableView reloadData];
    
    //setting up animation for reload data. From left to right.
    //TODO: Check if current date is larger or smaller to determine the
    //animation animates from left or right
    [self.recordTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSArray*)allDatesInWeek:(int)weekNumber {
    // determine weekday of first day of year:
    NSCalendar *greg = [[NSCalendar alloc]
                        initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = 1;
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [greg dateByAddingComponents:comps toDate:today  options:0];
    const NSTimeInterval kDay = [tomorrow timeIntervalSinceDate:today];
    comps = [greg components:NSYearCalendarUnit fromDate:[NSDate date]];
    comps.day = 1;
    comps.month = 1;
    comps.hour = 12;
    NSDate *start = [greg dateFromComponents:comps];
    comps = [greg components:NSWeekdayCalendarUnit fromDate:start];
    if (weekNumber==1) {
        start = [start dateByAddingTimeInterval:-kDay*(comps.weekday-1)];
    } else {
        start = [start dateByAddingTimeInterval:kDay*(8-comps.weekday+7*(weekNumber-2))];
    }
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        [result addObject:[start dateByAddingTimeInterval:kDay*i]];
    }
    return [NSArray arrayWithArray:result];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
