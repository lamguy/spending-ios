//
//  GI_Record.h
//  Spending
//
//  Created by Lam Nguyen on 2/7/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GI_Record : NSObject
@property(assign)NSInteger ID;
@property(assign)NSInteger cat_id;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *note;
@property(nonatomic, strong)NSString *address;
@property(assign)NSInteger amount;
@property(nonatomic, strong)NSDate *date_added;
@end
