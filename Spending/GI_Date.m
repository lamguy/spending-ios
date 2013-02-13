//
//  GI_Date.m
//  Spending
//
//  Created by Lam Nguyen on 2/7/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "GI_Date.h"

@implementation GI_Date
@synthesize selectedDate, selectedWeek;

static GI_Date *date = nil;

+ (GI_Date*)date {
    if (date == nil) {
        date = [[super allocWithZone:NULL] init];
        
        // initialize your variables here
        date.selectedDate = [NSDate date];
    }
    return date;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self)
	{
		if (date == nil)
		{
			date = [super allocWithZone:zone];
			return date;
		}
	}
	return nil;
}

+(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)fromDate andDate:(NSDate*)toDate
{
    if([date compare:fromDate] == NSOrderedAscending)
    {
        return NO;
    }
    
    if ([date compare:toDate] == NSOrderedDescending)
    {
        return NO;
    }
    
    return YES;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
@end
