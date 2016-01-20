//
//  AddActivityViewController.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "AddActivityViewController.h"
#import "ActivityDAO.h"
#import "HistoryDAO.h"
#import "UIViewController+NavigationHelper.h"
@interface AddActivityViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;



@property (nonatomic, strong) Activity * activity;
@end

@implementation AddActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activity = [Activity new];
    self.activity.current = YES;
    self.activity.rank = 1;
    self.activity.name = @"noname activity";
    [self createBackButton];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)nameDidChange:(id)sender {
    self.activity.name = self.nameField.text;
}

- (IBAction)addActivity:(id)sender
{
    [[ActivityDAO instance] addActivity:self.activity];
    [[HistoryDAO instance] addHistoryRecordWithDescription:[NSString stringWithFormat:@"Added %@ activity", (self.activity.current ? @"a current" : @"an ended")]];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)rankDidChange:(UIStepper *)sender {
    self.rankLabel.text = [NSString stringWithFormat:@"%i", (int)sender.value];
    self.activity.rank = sender.value;
}
- (IBAction)toggleCurrentlyHappening:(UISwitch *)sender {
    self.activity.current = sender.isOn;
}

@end
