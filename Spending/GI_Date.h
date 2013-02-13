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
    NSInteger selectedWeek;
}

@property(nonatomic, retain) NSDate *selectedDate;
@property(assign, readwrite) NSInteger selectedWeek;
+ (GI_Date*)date;
+(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)fromDate andDate:(NSDate*)toDate;
@end
