//
//  Record.h
//  Spending
//
//  Created by Lam Nguyen on 1/24/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject
@property(assign)NSInteger ID;
@property(assign)NSInteger cat_id;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *note;
@property(assign)NSInteger amount;
@end
