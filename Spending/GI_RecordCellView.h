//
//  GI_RecordCellView.h
//  Spending
//
//  Created by Lam Nguyen on 2/7/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GI_RecordCellView : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *recordCat;
@property (strong, nonatomic) IBOutlet UILabel *recordName;
@property (strong, nonatomic) IBOutlet UILabel *recordNote;
@property (strong, nonatomic) IBOutlet UILabel *recordAmount;

@end
