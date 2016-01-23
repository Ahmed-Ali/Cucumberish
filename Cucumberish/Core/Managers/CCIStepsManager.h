//
//  CCIStepsManager.h

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
#import "CCIStepDefinition.h"

@class CCIStep;
@class CCIStepDefinition;

/**
 Defines a Given implementations.
 
 @code
 Given(@"the app is running" ,  ^void(NSArray *args, id userInfo) {
    //Your step implementation goes here
    //The definition string in this case will match only the following step
    //Given the app is running
 });
 @endcode
 
 @Note
 Step definitions are checked in a "Last In First Out" order. If it happens that there are more than one definition matches a step, the last registered definition will be used.
 
 @param definitionString the regular expression that will checked against each Given step line.
 @param body the code block that will be executed if match is occured.
 */
OBJC_EXTERN void Given(NSString * definitionString, CCIStepBody body);

/**
 Defines a When step implementations.

 @b Example:
 @code
 When(@"^I tap (?:the )?\"([^\\\"]*)\" (?:button|view|label)$" ,  ^void(NSArray *args, id userInfo) {
    //Step implementation goes here
    //The definition string in this case can match all the following steps
    //When I tap the "MyButton" button
    //When I tap "MyButton" button
    //When I tap "Header" view
    //When I tap "FAQ" label
 });
 @endcode
 
 @Note
 Step definitions are checked in a "Last In First Out" order. If it happens that there are more than one definition matches a step, the last registered definition will be used.
 
 @param definitionString the regular expression that will checked against each Given step line.
 @param body the code block that will be executed if match is occured.
 */
OBJC_EXTERN void When(NSString * definitionString, CCIStepBody body);

/**
 Defines a Then step implementations.
 
 @b Example:
 @code
 Then(@"^I should see \"([^\\\"]*)\" in (?:the )?\"([^\\\"]*)\" (?:button|view|label)$" ,  ^void(NSArray *args, id userInfo) {
    //Step implementation goes here
    //The definition string in this case can match all the following steps
    //Then I should see "Button Title" in "MyButton" button
    //Then I should see "Button Title" in the "MyButton" Button
    //Then I should see "The Screen Title" in "Header" view
    //Then I should see "FAQ" in "FAQ" label
 });
 @endcode
 
 @Note
 Step definitions are checked in a "Last In First Out" order. If it happens that there are more than one definition matches a step, the last registered definition will be used.
 
 @param definitionString the regular expression that will checked against each Given step line.
 @param body the code block that will be executed if match is occured.
 */
OBJC_EXTERN void Then(NSString * definitionString, CCIStepBody body);

/**
 Defines an And step implementations.
 
 @b Example:
 @code
 And(@"^I should see \"([^\\\"]*)\" in (?:the )?\"([^\\\"]*)\" (?:button|view|label)$" ,  ^void(NSArray *args, id userInfo) {
    //Step implementation goes here
    //The definition string in this case can match all the following steps
    //And I should see "Button Title" in "MyButton" button
    //And I should see "Button Title" in the "MyButton" Button
    //And I should see "The Screen Title" in "Header" view
    //And I should see "FAQ" in "FAQ" label
 });
 @endcode
 
 @Note
 Step definitions are checked in a "Last In First Out" order. If it happens that there are more than one definition matches a step, the last registered definition will be used.
 
 @param definitionString the regular expression that will checked against each Given step line.
 @param body the code block that will be executed if match is occured.
 */
OBJC_EXTERN void And(NSString * definitionString, CCIStepBody body);

/**
 Defines a But step implementations.
 
 @code
 But(@"^I should see \"([^\\\"]*)\" in (?:the )?\"([^\\\"]*)\" (?:button|view|label)$" ,  ^void(NSArray *args, id userInfo) {
    //Step implementation goes here
    //The definition string in this case can match all the following steps
    //But I should see "Button Title" in "MyButton" button
    //But I should see "Button Title" in the "MyButton" Button
    //But I should see "The Screen Title" in "Header" view
    //But I should see "FAQ" in "FAQ" label
 });
 @endcode
 
 @Note
 Step definitions are checked in a "Last In First Out" order. If it happens that there are more than one definition matches a step, the last registered definition will be used.
 
 @param definitionString the regular expression that will checked against each Given step line.
 @param body the code block that will be executed if match is occured.
 */
OBJC_EXTERN void But(NSString * definitionString, CCIStepBody body);

/**
 Defines a step implementations that will be registered with When, Then, And, and But.
 The implementation of this function simply calls:
 @code
 When(definitionString, body);
 Then(definitionString, body);
 And(definitionString, body);
 But(definitionString, body);
 @endcode
 Which concluds that the registered definitions will be checked with any of these four prepositions.
 
 @b Example:
 @code
 MatchAll(@"^I should see \"([^\\\"]*)\" in (?:the )?\"([^\\\"]*)\" (?:button|view|label)$" ,  ^void(NSArray *args, id userInfo) {
    //Step implementation goes here
    //The definition string in this case can match all the following steps
    //When I should see "Button Title" in "MyButton" button
    //Then I should see "Button Title" in "MyButton" button
    //And I should see "Button Title" in "MyButton" button
    //But I should see "Button Title" in "MyButton" button
 });
 @endcode
 
 @Note
 Step definitions are checked in a "Last In First Out" order. If it happens that there are more than one definition matches a step, the last registered definition will be used.
 
 @param definitionString the regular expression that will checked against each Given step line.
 @param body the code block that will be executed if match is occured.
 */
OBJC_EXTERN void MatchAll(NSString * definitionString, CCIStepBody body);

/**
 Defines a step implementations that will be registered with specified prepositions.
 
 @b Example:
 @code
 Match(@[@"When", @"And", @"Then"], @"^I should see \"([^\\\"]*)\" in (?:the )?\"([^\\\"]*)\" (?:button|view|label)$" ,  ^void(NSArray *args, id userInfo) {
    //Step implementation goes here
    //The definition string in this case can match all the following steps
    //When I should see "Button Title" in "MyButton" button
    //And I should see "Button Title" in "MyButton" button
    //Then I should see "Button Title" in "MyButton" button
 });
 @endcode
 
 @Note
 Step definitions are checked in a "Last In First Out" order. If it happens that there are more than one definition matches a step, the last registered definition will be used.
 
 @param prepositions array of strings to be used as the preposition of the step definiton
 @param definitionString the regular expression that will checked against each Given step line.
 @param body the code block that will be executed if match is occured.
 */
OBJC_EXTERN void Match(NSArray *prepositions, NSString * definitionString, CCIStepBody body);

/**
 Step implementation can be also a useable code.
 If it the case that you want to call a previously defined step implementation, you can call this definition using this special step function.
 
 @Note
 Using this function, you do not need to worry about the preposition of the step; you just pass in the step line without defining the preposition.
 
 @b Example:
 @code
 //The first step definiton
 Match(@[@"When", @"And", @"Then"], @"^I should see \"([^\\\"]*)\" in (?:the )?\"([^\\\"]*)\" (?:button|view|label)$" ,  ^void(NSArray *args, id userInfo) {
    //Step implementation goes here
 });
 
 //The another step definiton that will make use of the previousely defined step
 When(@"^I write \"([^\\\"]*)\" (?:in|into) \"([^\\\"]*)\" field$" ,  ^void(NSArray *args, id userInfo) {
    //Step implementation goes here
    //Here you can call the previously defined step.
    step(@"I should see \"%@\" in the \"%@\" label", args[0], args[1]);
 });
 @endcode
 
 @param stepLine the step line string to be executed
 */
OBJC_EXPORT void step(NSString * stepLine, ...);

/**
 Swift alias for step(stepLine) function.
 */
OBJC_EXTERN void SStep(NSString * stepLine);

/**
 CCIStepsManager is a singleton class and its main purpose is to manage all step definitions and execute steps.
 */
@interface CCIStepsManager : NSObject

/**
 Returns the singleton class of CCIStepsManager
 */
+ (instancetype)instance;

/**
 Executes the passed steps if it matches any previously defined implementation. Or throw an error if there is no matching definiton.
 
 @param step the to be executed
 */
- (void)executeStep:(CCIStep *)step;

@end
