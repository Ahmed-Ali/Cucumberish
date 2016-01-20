//
//  ViewController.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "ViewController.h"
#import "ProfileDAO.h"
#import "HistoryDAO.h"
#import "ActivityDAO.h"
@interface ViewController ()

@end

@implementation ViewController


- (IBAction)clearAllData:(id)sender {
    [ProfileDAO instance].profile = [Profile new];
    [[ProfileDAO instance] saveProfile];
    [[HistoryDAO instance] clearHistory];
    [[ActivityDAO instance] clearActivities];
}

@end
