//
//  CCIStepsManager.h
//  CucumberishExample
//
//  Created by Ahmed Ali on 03/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCIExecutionResult.h"
#import "CCIStepDefinition.h"

@class CCIStep;
@class CCIStepDefinition;


OBJC_EXTERN void Given(NSString * definitionString, CCIStepBody body);
OBJC_EXTERN void When(NSString * definitionString, CCIStepBody body);
OBJC_EXTERN void Then(NSString * definitionString, CCIStepBody body);
OBJC_EXTERN void And(NSString * definitionString, CCIStepBody body);
OBJC_EXTERN void But(NSString * definitionString, CCIStepBody body);
OBJC_EXTERN void MatchAll(NSString * definitionString, CCIStepBody body);

OBJC_EXPORT CCIExecutionResult * step(NSString * stepLine);
OBJC_EXPORT CCIExecutionResult * steps(NSArray * steps);
@interface CCIStepsManager : NSObject


+ (instancetype)instance;

- (CCIExecutionResult *)executeStep:(CCIStep *)step;
@end
