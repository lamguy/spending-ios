//
//  SpendRecordCell.h
//  Spending
//
//  Created by Lam Nguyen on 1/24/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpendRecordCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *spendName;
@property (strong, nonatomic) IBOutlet UILabel *spendLocation;
@property (strong, nonatomic) IBOutlet UILabel *spendAmount;

@end
