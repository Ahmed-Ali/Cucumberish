//
//  ProfileViewController.m
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

#import "ProfileViewController.h"
#import "ProfileDAO.h"
#import "HistoryDAO.h"
#import "UIViewController+NavigationHelper.h"
@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdateDatePicker;
@property (weak, nonatomic) Profile * profile;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profile = [ProfileDAO instance].profile;
    [self fillData];
    [self createBackButton];
    
}

-(void)fillData
{
    self.emailField.text = self.profile.email;
    self.nameField.text = self.profile.name;
    if([self.profile.birthdate isKindOfClass:[NSDate class]]){
        self.birthdateDatePicker.date = self.profile.birthdate;
    }
}

- (IBAction)saveChanges:(id)sender {
    NSString * historyRecord;
    if(self.profile.name.length == 0 && self.profile.email.length == 0 && self.profile.birthdate == nil){
        historyRecord = @"Profile Created";
    }else{
        historyRecord = @"Profile Updated";
    }
    self.profile.email = self.emailField.text;
    self.profile.name = self.nameField.text;
    self.profile.birthdate = self.birthdateDatePicker.date;
    [[ProfileDAO instance] saveProfile];
    [[HistoryDAO instance] addHistoryRecordWithDescription:historyRecord];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
