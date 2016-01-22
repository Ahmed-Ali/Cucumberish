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
 Code blocks registerd with this function will receive two parameters: scenario instance and scenario execution block as a parameter.
 
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


/**
 Throws an exception with the specified reason.
 Cucumberish will handle this exception and show it as an issue with executing the current step
 
 @param reason the failure reason
 */
OBJC_EXTERN void throwCucumberishException(NSString *reason);;


/**
 Cucumberish is the main class you will need to parse your feature files and execute them.
 You should not create instances of this class directly, instead you need to use the instance method.
 
 @see +[Cucumberish instance]
*/
@interface Cucumberish : NSObject

/**
 As this being written, there is an issue with Xcode that causes the last scenario to disappear once it is done.
 If this causes an issue for your test report, change the value of this property to YES before calling beginExecution.
 
 @Note
 Thoguh the default value of this property is NO, ut is highly recommended to set the value of this proeprty to YES.
 
 @Note
 This will cause Cucumberish to execute an additional scenario called cucumberishCleanupScenario which will immediately disappear instead of your real last scenario.
 Which will also increase the number of executed scenarios by 1. If you only have 6 scenarios, you will see 7 scenarios in the console message, and in your report navigator.
 
 */
@property (nonatomic) BOOL fixMissingLastScenario;

/**
 Retuans a singleton instance of Cucumberish
 
 @return singleton instance of Cucumberish
 */
+ (instancetype)instance;


//param: featuresDirectory path in which to look for .feature files
//param: customStepsDirectory path in which to look for your .rb files
//param: tag only features annotated with this tag will be executed

/**
 Parses any .feature file that is located inside the passed folder name and map it to a test case if the feature inside the file has one or more tags of the passed tags (if any)
 
 @Note The feature directory has to be a real physical folder. Also When adding this folder to your test target, and get the prompt on how you would like to add it from Xcode, choose "Create Folder Reference" and @b NOT to Create Groups.
 
 @param featuresDirectory a path to your featuresDirectory relative to your test target main folder.
 @param tags array of strings to filter which the features that will be parsed to be executed.
 
 @return the singleton instance of Cucumberish so you can call beginExecution immediately if you want.
 */
- (Cucumberish *)parserFeaturesInDirectory:(NSString *)featuresDirectory featureTags:(NSArray *)tags;

/**
 Start executing all the previously parsed features in an alphabetic ascending order.
 */
- (void)beginExecution;

/**
 Conventient method that calls parserFeaturesInDirectory:featureTags: followed by an immediate call to beginExecution
 
 @Note The feature directory has to be a real physical folder. Also When adding this folder to your test target, and get the prompt on how you would like to add it from Xcode, choose "Create Folder Reference" and @b NOT to Create Groups.
 
 @param featuresDirectory a path to your featuresDirectory relative to your test target main folder.
 @param tags array of strings to filter which the features that will be parsed to be executed.
 
 */
+ (void)executeFeaturesInDirectory:(NSString *)featuresDirectory featureTags:(NSArray *)tags;
@end


