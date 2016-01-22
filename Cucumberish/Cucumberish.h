//
//  Cucumberish.h

//
//  Created by Ahmed Ali on 03/01/16.
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

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "CCIStepsManager.h"
#import "CCIScenarioDefinition.h"
#import "CCIHock.h"
#import "CCIAroundHock.h"

/**
 C function that registers a code block to be called only once before executing any test case.
 You can call this function as much as you want, but only the last registerd code block will be used.
 
 @Note
 This function should not be called after calling @a beginExecution.
 
 @param beforeStartBlock code block that will be executed once before any test cases.
 */
OBJC_EXTERN void beforeStart(void(^beforeStartBlock)(void));


/**
 C function that registers a code block to be called only once after executing all test cases.
 You can call this function as much as you want, but only the last registerd code block will be used.
 
 @Note
 This function should not be called after calling @a beginExecution.
 
  @param afterFinishBlock code block that will be executed once after all test cases finish execution.
 */
OBJC_EXTERN void afterFinish(void(^afterFinishBlock)(void));


/**
 C function that registers a code block to be called before each scenario.
 Code blocks registerd with this function will run before each scenario in the same order they were orignally registered; that's it, FIFO (First In First Out).
 
 @Note
 This function should not be called after calling @a beginExecution.
 
 @param beforeEachBlock code block that will be executed before executing the scenario, this block receives an instance of the scenario that will be executed.
 */
OBJC_EXTERN void before(CCIScenarioHockBlock beforeEachBlock);


/**
 C function that registers a code block to be called after each scenario.
 Code blocks registerd with this function will run after each scenario in reversed order compared to the order they were orignally registered; that's it, LIFO (Last In First Out)
 
 @Note
 All code blocks registerd with this function, will run regardless the scenario has been passed or not

 @Note
 This function should not be called after calling @a beginExecution.
 
 @param afterEachBlock code block that will be executed after executing the scenario, this block receives an instance of the scenario that has been executed.
 */
OBJC_EXTERN void after(CCIScenarioHockBlock afterEachBlock);


/**
 C function that registers a code block to be called before each scenario that has one or more tag that matches one or more tags passed to this function.
 Code blocks registerd with this function will run before each matching scenario in the same order they were orignally registered; that's it, FIFO (First In First Out)
 
 @Note
 Do not prefix any tag you pass with @ symbol
 
 @Note
 This function should not be called after calling @a beginExecution.
 
 @param tags array of strings that will be used to match specific scenarios
 @param beforeTaggedBlock code block that will be executed before executing the scenario, this block receives an instance of the scenario that will be executed.
 */
OBJC_EXTERN void beforeTagged(NSArray * tags, CCIScenarioHockBlock beforeTaggedBlock);


/**
 C function that registers a code block to be called after each scenario that has one or more tag that matches one or more tags passed to this function.
 Code blocks registerd with this function will run after each matching scenario in reversed order compared to the order they were orignally registered; that's it, LIFO (Last In First Out)
 
 @Note
 This function should not be called after calling @a beginExecution.
 
 @Note
 All code blocks registerd with this function, will run regardless the matching scenario has been passed or not
 
 @Note
 Do not prefix any tag you pass with @ symbol
 
 @param tags array of strings that will be used to match specific scenarios
 @param afterTaggedBlock code block that will be executed after executing the scenario, this block receives an instance of the scenario that has been executed.
 */
OBJC_EXTERN void afterTagged(NSArray * tags, CCIScenarioHockBlock afterTaggedBlock);


/**
 C function that registers a code block to be used to call the scenario execution block.
 Code blocks registerd with this function will receive to parameter: scenario instance and scenario execution block as a parameter.
 
 If more than one code block matches the scenario, you are still required to call the scenario execution from each registered code block. However, your scenario will be executed once as it is supposed to be.

 Matching against around blocks happens in FIFO (First In First Out) order; in case more than one block has matched the same scenario, then they are nested.
 
 @Note
 Failing to call the scenario execution block, will prevent the scenario from being executed.
 
 @b Example of more than one match
 
 There are three registerd blocks with tags that matches the same scenario, the followin nesting calls will happen:
 
 @code
Third Around Match
    Block = contains code block that executes the Second Around Match
        Second Around Match
            Block = contains code block that executes the First Around Match
                First Around Match
                    Block = A call Scenario Exection Block@endcode
 
 
 @Note
 Do not prefix any tag you pass with @@ symbol
 
 @Note
 This function should not be called after calling @a beginExecution.
 
 
 @param tags array of strings that will be used to match specific scenarios
 @param aroundScenarioBlock code block that will be executed for each scneario, this block receives an instance of the scenario and the scenario execution block.
 */
OBJC_EXTERN void around(NSArray * tags, CCIScenarioExecutionHockBlock aroundScenarioBlock);


/**
 Boolean assertion function. Use it where you usually use NSAssert or assert.
 
 Using this assertion function in your step implementations, guarantees proper error reporting
 
 @param expression boolean expression
 @param failureMessage formatted a string describe what went wrong in case expression is evaluated to false
 */
OBJC_EXTERN void CCIAssert(BOOL expression, NSString * failureMessage, ...);


OBJC_EXTERN void throwCucumberishException(NSString *reason);;

@interface Cucumberish : NSObject


@property (nonatomic) BOOL fixMissingLastScenario;

+ (instancetype)instance;


//param: featuresDirectory path in which to look for .feature files
//param: customStepsDirectory path in which to look for your .rb files
//param: tag only features annotated with this tag will be executed

/**
 
 */
- (Cucumberish *)parserFeaturesInDirectory:(NSString *)featuresDirectory featureTags:(NSArray *)tags;

- (void)beginExecution;
@end


