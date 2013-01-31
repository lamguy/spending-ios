//
//  SpendDate.m
//  Spending
//
//  Created by Lam Nguyen on 1/31/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "SpendDate.h"

@implementation SpendDate
@synthesize selectedDate;

static SpendDate *currentDate = nil;

+ (SpendDate*)currentDate {
    if (currentDate == nil) {
        currentDate = [[super allocWithZone:NULL] init];
        
        // initialize your variables here
        currentDate.selectedDate = [NSDate date];
    }
    return currentDate;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self)
	{
		if (currentDate == nil)
		{
			currentDate = [super allocWithZone:zone];
			return currentDate;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
@end
