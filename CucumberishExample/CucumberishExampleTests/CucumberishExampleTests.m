//
//  CucumberishExampleTests.m
//  CucumberishExampleTests
//
//  Created by Ahmed Ali on 20/01/16.
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

#import <XCTest/XCTest.h>

#import "Cucumberish.h"
#import "CCIStepsUsingKIF.h"
#import "KIFUITestActor+Utils.h"

__attribute__((constructor))
void CucumberishInit()
{
    [CCIStepsUsingKIF setup];
    KIFUITestActor * actor = [CCIStepsUsingKIF instance].actor;
    Given(@"it is home screen", ^void(NSArray *args, id userInfo) {
        while ([actor isViewExistForAccessibilityLabel:@"Nav Back"]) {
            [actor tapViewWithAccessibilityLabel:@"Nav Back"];
        }
    });
    
    And(@"all data cleared", ^void(NSArray *args, id userInfo) {
        step(@"I tap the \"Clear All Data\" button");
    });
    
    
    /**
     Feature: Example
     # This is a free text description as an inline documentation for your features, you can omit it if you want.
     # However, it is very adviseble to well describe your features.
     As someone who plan to automate the iOS projet test cases, I will use Cucumberish.
     
     # First scenario is the scenario name, which will also appear in a proper formatting in the test navigator
     Scenario: First scenario
     # This is the first step in the scenario
     # Also noteworthy; a "Given" step, should be treated as the step the defines the app state before going into the rest of the scenario
     # Or consider it as a precondition for the scenario;
     # For example to post a comment, the user most be logged in, then you should say something similar to "Given the user is logged in" as your Given step.
     Given I have a very cool app
     
     # The grammar being used, is completely defined by you and your QA team; it is up to you to find the best way to define your functionality.
     # Only keep in mind that every step must start with "Given", "When", "Then", "And", and "But".
     When I automate it with "Cucumberish"
     Then I will be more confident about the quality of the project and its releases
     */
    
    Given(@"I have a very cool app", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        //Inside this step implementation, it is expected that you will do whatever necessary to make sure "I have a very cool app" condition is satisfied :)
        NSLog(@"\"Given I have a very cool app\" step is implemented");
    });
    
    // The step implementation matching text can be any valid regular expression text
    // Your regex captured groups will be added to the args array in the same order they have been captured by you regex string
    When(@"^I automate it with \"(.*)\"$", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        NSLog(@"I am gonna automate my test cases with \"%@\"", args[0]);
    });
    
    Then(@"Then I will be more confident about the quality of the project and its releases", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        NSLog(@"Implemented step for the sake of the example");
    });
    
    
    [Cucumberish instance].fixMissingLastScenario = YES;
    [[[Cucumberish instance] parserFeaturesInDirectory:@"ExampleFeatures" featureTags:nil] beginExecution];
}