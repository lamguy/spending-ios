//
//  SpendDate.h
//  Spending
//
//  Created by Lam Nguyen on 1/31/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpendDate : NSObject
{
    NSDate *selectedDate;
}

@property(nonatomic, retain) NSDate *selectedDate;
+ (SpendDate*)currentDate;
@end
