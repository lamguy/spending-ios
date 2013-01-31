//
//  GraphingViewController.m
//  Spending
//
//  Created by Lam Nguyen on 1/21/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "GraphingViewController.h"

@implementation GraphingViewController
float data[] = {0.7, 0.0, 0.0, 1.0, 0.3, 0.85, 0.3};
CGRect touchAreas[kNumberOfBars];

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:(240.0/255.0) green:(144.0/255.0) blue:(111.0/255.0) alpha:1.0] CGColor]);
    int maxGraphHeight = kGraphHeight - kOffsetY;
    
    /*
    // Filling the Graph
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] CGColor]);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    for (int i = 1; i < sizeof(data); i++)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    CGContextAddLineToPoint(ctx, kOffsetX + (sizeof(data) - 1) * kStepX, kGraphHeight);
    CGContextClosePath(ctx);
    //CGContextDrawPath(ctx, kCGPathFill);
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {1.0, 0.5, 0.0, 0.2,  // Start color
        1.0, 0.5, 0.0, 1.0}; // End color
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    CGPoint startPoint, endPoint;
    startPoint.x = kOffsetX;
    startPoint.y = kGraphHeight;
    endPoint.x = kOffsetX;
    endPoint.y = kOffsetY;
    
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
     
     */
    
    
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * data[0]);
    for (int i = 0; i < 7; i++)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * data[i]);
    }
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] CGColor]);
    CGContextSetRGBStrokeColor(ctx, (240.0/255.0), (144.0/255.0), (111.0/255.0), 1.0);
    CGContextSetLineWidth(ctx, 2.0);
    for (int i = 0; i < 7; i++)
    {
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * data[i];
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(ctx, rect);
        
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
}

- (void)drawBar:(CGRect)rect context:(CGContextRef)ctx
{
    // Prepare the resources
    CGFloat components[12] = {0.2314, 0.5686, 0.4, 1.0,  // Start color
        0.4727, 1.0, 0.8157, 1.0, // Second color
        0.2392, 0.5686, 0.4118, 1.0}; // End color
    CGFloat locations[3] = {0.0, 0.33, 1.0};
    size_t num_locations = 3;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    //CGPoint startPoint = rect.origin;
    //CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    // Create and apply the clipping path
    CGContextBeginPath(ctx);
    CGContextSetGrayFillColor(ctx, 0.2, 0.7);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(ctx);
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    // Draw the gradient
    //CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    // Release the resources
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
}

- (void)drawBarGraphWithContext:(CGContextRef)ctx
{
    // Draw the bars
    float maxBarHeight = kGraphHeight - kBarTop - kOffsetY;
    for (int i = 0; i < kNumberOfBars; i++)
    {
        float barX = 20 + i * kStepX - kBarWidth / 2;
        float barY = kBarTop + maxBarHeight - maxBarHeight;
        float barHeight = maxBarHeight + 20;
        CGRect barRect = CGRectMake(barX, barY, kBarWidth, barHeight);
        [self drawBar:barRect context:ctx];
        touchAreas[i] = barRect;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    for (int i = 0; i < kNumberOfBars; i++)
    {
        if (CGRectContainsPoint(touchAreas[i], point))
        {
            NSLog(@"Tapped a bar with index %d, value %f", i, data[i]);
            break;
        }
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    // How many lines?
    int howMany = 7;
    // Here the lines go
    for (int i = 0; i < howMany; i++)
    {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom-33);
    }
    
    
    int howManyHorizontal = 2;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - 33 - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - 33 - i * kStepY);
    }
    
    
    CGContextStrokePath(context);
    
    CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
    
    [self drawLineGraphWithContext:context];
    [self drawBarGraphWithContext:context];
    
    
    
    // Get an array of weekdays
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    NSArray *weekdays = [df shortWeekdaySymbols];
    
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSWeekCalendarUnit fromDate:date];
    NSInteger week = [components week];
    
    
    NSArray *weekdate = [self allDatesInWeek:week];
    
    for (int i=0; i<[weekdate count]; i++) {
        NSLog(@"%@", [weekdate objectAtIndex:i]);
    }
    
    NSLog(@"%d", week);
    NSLog(@"%d", [weekdate count]);
    
    // Horizontial point chart text
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, "Helvetica", 8, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    
    for (int i = 0; i<[weekdays count]; i++) {
        NSString *theText = [NSString stringWithFormat:@"%@", [weekdays objectAtIndex:i]];
        CGContextShowTextAtPoint(context, kOffsetX + i * kStepX - 8, kGraphBottom - 20, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
    }
    
    
    for (int i = 1; i<3; i++)
    {
        NSString *theRange = [NSString stringWithFormat:@"%d", i*100];
        CGContextShowTextAtPoint(context, kOffsetX-20, kGraphBottom - 30 - i * kStepY, [theRange cStringUsingEncoding:NSUTF8StringEncoding], [theRange length]);
    }
}

-(NSArray*)allDatesInWeek:(int)weekNumber {
    // determine weekday of first day of year:
    NSCalendar *greg = [[NSCalendar alloc]
                        initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = 1;
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [greg dateByAddingComponents:comps toDate:today  options:0];
    const NSTimeInterval kDay = [tomorrow timeIntervalSinceDate:today];
    comps = [greg components:NSYearCalendarUnit fromDate:[NSDate date]];
    comps.day = 1;
    comps.month = 1;
    comps.hour = 12;
    NSDate *start = [greg dateFromComponents:comps];
    comps = [greg components:NSWeekdayCalendarUnit fromDate:start];
    if (weekNumber==1) {
        start = [start dateByAddingTimeInterval:-kDay*(comps.weekday-1)];
    } else {
        start = [start dateByAddingTimeInterval:kDay*(8-comps.weekday+7*(weekNumber-2))];
    }
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i<7; i++) {
        [result addObject:[start dateByAddingTimeInterval:kDay*i]];
    }
    return [NSArray arrayWithArray:result];
}

@end
