//
//  ActivityDAO.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "ActivityDAO.h"

@implementation ActivityDAO
+ (instancetype)instance
{
    static ActivityDAO * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ActivityDAO new];
    });
    
    return instance;
}
- (NSArray *)currentActivities
{
    if(_currentActivities == nil){
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentActivities"];
        _currentActivities = [NSKeyedUnarchiver unarchiveObjectWithData:data] ? : @[];
    }
    
    return _currentActivities;
}
- (NSArray *)endedActivities
{
    if(_endedActivities == nil){
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"EndedActivities"];
        _endedActivities = [NSKeyedUnarchiver unarchiveObjectWithData:data] ? : @[];
    }
    
    return _endedActivities;
}
- (void)addActivity:(Activity *)activity
{
    
    NSMutableArray * activities = activity.current ? [self.currentActivities mutableCopy] : [self.endedActivities mutableCopy];
    [activities addObject:activity];
    if(activity.current){
        self.currentActivities = [NSArray arrayWithArray:activities];
    }else{
        self.endedActivities = [NSArray arrayWithArray:activities];
    }
    [self saveActivities];
}
- (void)deleteActivity:(Activity *)activity
{
    NSMutableArray * activities = activity.current ? [self.currentActivities mutableCopy] : [self.endedActivities mutableCopy];
    [activities removeObject:activity];
    if(activity.current){
        self.currentActivities = [NSArray arrayWithArray:activities];
    }else{
        self.endedActivities = [NSArray arrayWithArray:activities];
    }
    [self saveActivities];
}


- (void)clearActivities
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentActivities"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EndedActivities"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _currentActivities = @[];
    _endedActivities = @[];
}

- (void)saveActivities
{
    NSData * activitiesData = [NSKeyedArchiver archivedDataWithRootObject:self.currentActivities];
    [[NSUserDefaults standardUserDefaults] setObject:activitiesData forKey:@"CurrentActivities"];
    activitiesData = [NSKeyedArchiver archivedDataWithRootObject:self.endedActivities];
    [[NSUserDefaults standardUserDefaults] setObject:activitiesData forKey:@"EndedActivities"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
