//
//  ProfileViewController.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

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
