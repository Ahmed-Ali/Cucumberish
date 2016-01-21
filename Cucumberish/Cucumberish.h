//
//  Cucumberish.h
//  CucumberishExample
//
//  Created by Ahmed Ali on 03/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

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


