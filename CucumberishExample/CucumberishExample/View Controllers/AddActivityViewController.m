//
//  AddActivityViewController.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
    [self.nameField resignFirstResponder];
}
- (IBAction)toggleCurrentlyHappening:(UISwitch *)sender {
    self.activity.current = sender.isOn;
    
    [self.nameField resignFirstResponder];
}

@end
