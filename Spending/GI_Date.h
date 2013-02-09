//
//  GI_Date.h
//  Spending
//
//  Created by Lam Nguyen on 2/7/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GI_Date : NSObject
{
    NSDate *selectedDate;
}

@property(nonatomic, retain) NSDate *selectedDate;
+ (GI_Date*)date;

@end
