//
//  CategoriesController.m
//  Spending
//
//  Created by Lam Nguyen on 1/29/13.
//  Copyright (c) 2013 Geniuspilot Interactive. All rights reserved.
//

#import "CategoriesController.h"

@interface CategoriesController () <NILauncherViewModelDelegate>
@property (nonatomic, readwrite, retain) NILauncherViewModel* model;

@end

@implementation CategoriesController
@synthesize model = _model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.title = @"Model";
        
        // Load the Nimbus app icon.
        NSString* imagePath = NIPathForBundleResource(nil, @"cat_housing.png");
        UIImage* image = [[Nimbus imageMemoryCache] objectWithName:imagePath];
        if (nil == image) {
            image = [UIImage imageWithContentsOfFile:imagePath];
            [[Nimbus imageMemoryCache] storeObject:image withName:imagePath];
        }
        
        // We populate the launcher model with an array of arrays of NILauncherViewObject objects.
        // Each sub array is a single page of the launcher view. The default NILauncherViewObject object
        // allows you to provide a title and image.
        NSArray* contents =
        [NSArray arrayWithObjects:
         [NSArray arrayWithObjects:
          [NILauncherViewObject objectWithTitle:@"Nimbus" image:image],
          [NILauncherViewObject objectWithTitle:@"Nimbus 2" image:image],
          [NILauncherViewObject objectWithTitle:@"Nimbus 3" image:image],
          [NILauncherViewObject objectWithTitle:@"Nimbus 5" image:image],
          [NILauncherViewObject objectWithTitle:@"Nimbus 6" image:image],
          nil],
         
         // A new page.
         [NSArray arrayWithObjects:
          [NILauncherViewObject objectWithTitle:@"Page 2" image:image],
          nil],
         
         // A third page.
         [NSArray arrayWithObjects:
          [NILauncherViewObject objectWithTitle:@"Page 3" image:image],
          nil],
         nil];
        
        // Create the model object with the contents array. We provide self as the delegate so that
        // we can customize what the buttons look like.
        _model = [[NILauncherViewModel alloc] initWithArrayOfPages:contents delegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    
    // Because the model implements the NILauncherViewDataSource protocol we can simply assign the
    // model to the dataSource property and everything will magically work. Wicked!
    self.launcherView.dataSource = self.model;
}

#pragma mark - NILauncherViewModelDelegate

- (void)launcherViewModel:(NILauncherViewModel *)launcherViewModel
      configureButtonView:(UIView<NILauncherButtonView> *)buttonView
          forLauncherView:(NILauncherView *)launcherView
                pageIndex:(NSInteger)pageIndex
              buttonIndex:(NSInteger)buttonIndex
                   object:(id<NILauncherViewObject>)object {
    
    // The NILauncherViewObject object always creates a NILauncherButtonView so we can safely cast
    // here and update the label's style to add the nice blurred shadow we saw in the
    // BasicInstantiation example.
    NILauncherButtonView* launcherButtonView = (NILauncherButtonView *)buttonView;
    
    launcherButtonView.label.layer.shadowColor = [UIColor blackColor].CGColor;
    launcherButtonView.label.layer.shadowOffset = CGSizeMake(0, 1);
    launcherButtonView.label.layer.shadowOpacity = 1;
    launcherButtonView.label.layer.shadowRadius = 1;
}

#pragma mark - NILauncherDelegate

- (void)launcherView:(NILauncherView *)launcher didSelectItemOnPage:(NSInteger)page atIndex:(NSInteger)index {
    // Now that we're using a model we can easily refer back to which object was selected when we
    // receive a selection notification.
    id<NILauncherViewObject> object = [self.model objectAtIndex:index pageIndex:page];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:[@"Did tap button with title: " stringByAppendingString:object.title]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
