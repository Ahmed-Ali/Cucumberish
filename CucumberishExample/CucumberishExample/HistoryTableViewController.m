//
//  HistoryTableViewController.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryDAO.h"
@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController


- (IBAction)clearAll:(id)sender{
    [[HistoryDAO instance] clearHistory];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [HistoryDAO instance].historyRecords.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    cell.textLabel.text = [[HistoryDAO instance] historyRecords][indexPath.row];
    
    
    return cell;
}



@end
