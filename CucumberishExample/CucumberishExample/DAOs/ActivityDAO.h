//
//  ActivityDAO.h
//  CucumberishExample
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"
@interface ActivityDAO : NSObject
@property (nonatomic, strong) NSArray * currentActivities;
@property (nonatomic, strong) NSArray * endedActivities;

+ (instancetype)instance;

- (void)addActivity:(Activity *)activity;
- (void)deleteActivity:(Activity *)activity;


- (void)clearActivities;
@end
