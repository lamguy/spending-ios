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
@synthesize titleA;
NSInteger week;

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
	// Do any additional setup after loading the view.
    titleA = [[UILabel alloc] initWithFrame:self.view.frame];
    NSLog(@" label %f", self.view.frame.size.width);
    titleA.frame = CGRectMake(0, 0, 200, 100);
    titleA.text = [NSString stringWithFormat:@"Week %d", weekNumber];
    
    [self.view addSubview:titleA];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
