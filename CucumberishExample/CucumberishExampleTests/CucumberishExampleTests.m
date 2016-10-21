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

@interface ClassThatLocatedInTheRootTestTargetFolder : NSObject

@end

@implementation ClassThatLocatedInTheRootTestTargetFolder


@end

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
        step(nil, @"I tap the \"Clear All Data\" button");
    });
    
    
    [[Cucumberish instance] setPrettyNamesAllowed:YES];
    [Cucumberish instance].fixMissingLastScenario = YES;
    NSBundle * bundle = [NSBundle bundleForClass:[ClassThatLocatedInTheRootTestTargetFolder class]];
    [Cucumberish executeFeaturesInDirectory:@"ExampleFeatures" fromBundle:bundle includeTags:nil excludeTags:nil];
}
