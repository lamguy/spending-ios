//
//  Spending_ViewController.m
//  Spending
//
//  Created by Lam Nguyen on 1/21/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "Spending_ViewController.h"
#import "SpendRecordCell.h"

@interface Spending_ViewController ()
{
    NSMutableArray *arrayOfRecord;
    sqlite3 *recordDB;
    NSString *dbPathString;
}

@end

@implementation Spending_ViewController

@synthesize graphScroller;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Change view background app-wide
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    
    
    //Set new background for regular buttons
    UIImage* RegButtonBlue = [[UIImage imageNamed:@"regular_button_blue.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 3, 0, 3)];
    self.addNewSpend.frame = CGRectMake(0.0, 44.0, 314, 24);
    [self.addNewSpend setBackgroundImage:RegButtonBlue forState:UIControlStateNormal];
    self.addNewSpend.titleLabel.shadowColor = [UIColor colorWithRed:(42.0/255.0) green:(123.0/255.0) blue:(190.0/255.0) alpha:1.0];
    self.addNewSpend.titleLabel.shadowOffset = CGSizeMake(0, -1.0);
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    arrayOfRecord = [[NSMutableArray alloc]init];
    [[self recordTableView]setDelegate:self];
    [[self recordTableView]setDataSource:self];
    [self createOrOpenDB];
    
    
    
    NSLog(@"opend db to pull");
    
    sqlite3_stmt *query_stmt;
    
    if (sqlite3_open([dbPathString UTF8String], &recordDB)==SQLITE_OK) {
        NSLog(@"opend db to pull");
        [arrayOfRecord removeAllObjects ];
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM SPENDS"];
        
        if (sqlite3_prepare(recordDB, [querySQL UTF8String], -1, &query_stmt, NULL)==SQLITE_OK) {
            NSLog(@"prepared to pull");
            while (sqlite3_step(query_stmt)==SQLITE_ROW) {
                NSString *name=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(query_stmt, 2)];
                NSString *note=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(query_stmt, 3)];
                
                Record *record = [[Record alloc]init];
                
                [record setName:name];
                [record setNote:note];
                
                [arrayOfRecord addObject:record];
                
                NSLog(@"pulled");
            }
        }
    }

}

-(void)createOrOpenDB
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    dbPathString = [docPath stringByAppendingPathComponent:@"spending.db"];
    
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dbPathString])
    {
        const char *dbPath = [dbPathString UTF8String];
        
        //create db here
        if(sqlite3_open(dbPath, &recordDB)==SQLITE_OK)
        {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS SPENDS(ID INTEGER PRIMARY KEY AUTOINCREMENT, CAT_ID INTEGER, NAME TEXT, NOTE TEXT)";
            sqlite3_exec(recordDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(recordDB);
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfRecord count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"SpendingRecordCell";
    SpendRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Record *aRecord = [arrayOfRecord objectAtIndex:indexPath.row];
    
    cell.spendName.text = aRecord.name;
    cell.spendLocation.text = aRecord.note;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

@end
