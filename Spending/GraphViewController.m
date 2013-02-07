//
//  GraphViewController.m
//  Spending
//
//  Created by Lam Nguyen on 2/6/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()

@end

@implementation GraphViewController
@synthesize graphView;
sqlite3 *recordDB;
NSString *dbPathString;
NSArray *weekdate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithWeeknumber:(int)week
{
    
    weekNumber = week;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    graphView = [[GraphingViewController alloc] init];
    [self loadData];
    graphView.week = weekNumber;
    graphView.frame = CGRectMake(0, 0, 300, 144);
    graphView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.view addSubview:graphView];
    
}

- (void)loadData
{    
    NSDate *date = [SpendDate currentDate].selectedDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSWeekCalendarUnit fromDate:date];
    weekNumber = [components week];
    NSLog(@"week fucking week %d", weekNumber);
    weekdate = [self allDatesInWeek:weekNumber];
    
    sqlite3_stmt *query_stmt;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    dbPathString = [docPath stringByAppendingPathComponent:@"spending.db"];
    [graphView.data removeAllObjects ];
    
    for (int i=0; i<[weekdate count]; i++) {
        NSNumber *amount = [[NSNumber alloc] initWithInt:0];
        
        if (sqlite3_open([dbPathString UTF8String], &recordDB)==SQLITE_OK) {
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString=[dateFormat stringFromDate:weekdate[i]];
            
            NSString *querySQL = [NSString stringWithFormat:@"SELECT SUM(AMOUNT) FROM SPENDS WHERE DATE_ADDED=?"];
            
            if (sqlite3_prepare(recordDB, [querySQL UTF8String], -1, &query_stmt, NULL)==SQLITE_OK) {
                sqlite3_bind_text(query_stmt, 1, [dateString UTF8String], -1, SQLITE_TRANSIENT);
                while (sqlite3_step(query_stmt)==SQLITE_ROW) {
                    amount = [NSNumber numberWithInt:sqlite3_column_int(query_stmt, 0)];
                }
            }
        }
        [graphView.data addObject:amount];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
