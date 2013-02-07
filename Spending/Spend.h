//
//  Spend.h
//  Spending
//
//  Created by Lam Nguyen on 1/21/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spend : NSObject {
}

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *location;

@end
