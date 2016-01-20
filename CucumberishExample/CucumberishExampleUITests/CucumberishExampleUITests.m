//
//  CucumberishExampleUITests.m
//  CucumberishExampleUITests
//
//  Created by Ahmed Ali on 19/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Cucumberish.h"
@interface NSObject (Cucumberish) @end
@implementation NSObject (Cucumberish)


+ (void)load
{
    Given(@"^there are (\\d*) cucumbers$", ^CCIExecutionResult *(NSArray *args, id userInfo) {
        NSLog(@"I started with: %@", args[0]);
        return [CCIExecutionResult status:CCIExecutionStatusPass reason:nil];
    });
    
    When(@"^I eat (\\d*) cucumbers$", ^CCIExecutionResult *(NSArray *args, id userInfo) {
        NSLog(@"I started with: %@", args[0]);
        return [CCIExecutionResult status:CCIExecutionStatusPass reason:nil];
    });
    Then(@"^I should have (\\d*) cucumbers$", ^CCIExecutionResult *(NSArray *args, id userInfo) {
        NSLog(@"Then I should have: %@", args[0]);
        return [CCIExecutionResult status:CCIExecutionStatusPass reason:nil];
    });
    Given(@"^an expense report for (.*) with the following posts:$", ^CCIExecutionResult *(NSArray *args, id userInfo) {
        
        return [CCIExecutionResult status:CCIExecutionStatusPass reason:nil];
    });
    Given(@"^a blog post named \"([^\\\"]*)\" with Markdown body$", ^CCIExecutionResult *(NSArray *args, id userInfo) {
        
        return [CCIExecutionResult status:CCIExecutionStatusPass reason:nil];
    });
    
    
//    [[CCIStepsUsingKIF instance] createUIStepDefinitionsWithKIF];
    [Cucumberish instance].fixMissingLastScenario = YES;
    [[[Cucumberish instance] parserFeaturesInDirectory:@"ExampleFeatures" featureTags:nil] beginExecution];
}

@end
