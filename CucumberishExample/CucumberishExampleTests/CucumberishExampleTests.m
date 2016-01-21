//
//  CucumberishExampleTests.m
//  CucumberishExampleTests
//
//  Created by Ahmed Ali on 20/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Cucumberish.h"
#import "CCIStepsUsingKIF.h"
#import "KIFUITestActor+Utils.h"

@interface NSObject (Cucumberish) @end
@implementation NSObject (Cucumberish)


+ (void)load
{
    [CCIStepsUsingKIF setup];
    KIFUITestActor * actor = [CCIStepsUsingKIF instance].actor;
    Given(@"it is home screen", ^void(NSArray *args, id userInfo) {
        while ([actor isViewExistForAccessibilityLabel:@"Nav Back"]) {
            [actor tapViewWithAccessibilityLabel:@"Nav Back"];
        }
    });
    
    And(@"all data cleared", ^void(NSArray *args, id userInfo) {
        return step(@"I tap the \"Clear All Data\" button");
    });
    
        
    
    
    [Cucumberish instance].fixMissingLastScenario = YES;
    [[[Cucumberish instance] parserFeaturesInDirectory:@"ExampleFeatures" featureTags:nil] beginExecution];
}

@end