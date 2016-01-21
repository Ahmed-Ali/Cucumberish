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


OBJC_EXTERN void beforeStart(void(^beforeStartBlock)(void));
OBJC_EXTERN void afterFinish(void(^afterFinishBlock)(void));

OBJC_EXTERN void before(CCIScenarioHockBlock beforeEachBlock);
OBJC_EXTERN void after(CCIScenarioHockBlock afterEachBlock);

OBJC_EXTERN void beforeTagged(NSArray * tags, CCIScenarioHockBlock beforeTaggedBlock);
OBJC_EXTERN void afterTagged(NSArray * tags, CCIScenarioHockBlock afterTaggedBlock);

OBJC_EXTERN void around(NSArray * tags, CCIScenarioExecutionHockBlock aroundScenarioBlock);

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


