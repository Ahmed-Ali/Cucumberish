//
//  ActivityDAO.m
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
