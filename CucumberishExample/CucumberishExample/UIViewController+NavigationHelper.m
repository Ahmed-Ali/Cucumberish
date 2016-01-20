//
//  UIViewController+NavigationHelper.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 20/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "UIViewController+NavigationHelper.h"

@implementation UIViewController (NavigationHelper)
- (void)createBackButton
{
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backItem.accessibilityLabel = @"Nav Back";
    self.navigationItem.leftBarButtonItems = @[ backItem];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
