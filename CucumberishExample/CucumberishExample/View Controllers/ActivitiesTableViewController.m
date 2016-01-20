//
//  ActivitiesTableViewController.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "ActivitiesTableViewController.h"
#import "ActivityDAO.h"
#import "HistoryDAO.h"
#import "UIViewController+NavigationHelper.h"
@interface ActivitiesTableViewController ()

@end

@implementation ActivitiesTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackButton];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return [ActivityDAO instance].currentActivities.count;
    }
    return [ActivityDAO instance].endedActivities.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"Current activities";
    }
    
    return @"Ended activities";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    Activity * activity = indexPath.section == 0 ? [ActivityDAO instance].currentActivities[indexPath.row] : [ActivityDAO instance].endedActivities[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%i)", activity.name, (int)activity.rank];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Activity * activity = indexPath.section == 0 ? [ActivityDAO instance].currentActivities[indexPath.row] : [ActivityDAO instance].endedActivities[indexPath.row];
        [[ActivityDAO instance] deleteActivity:activity];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[HistoryDAO instance] addHistoryRecordWithDescription:[NSString stringWithFormat:@"Deleted %@ activity", (activity.current ? @"a current" : @"an ended")]];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
