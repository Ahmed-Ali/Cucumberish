//
//  CCIStepDefinition.h
//  CucumberishExample
//
//  Created by Ahmed Ali on 02/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CCIExecutionResult;
@class CCIStep;

typedef CCIExecutionResult * (^CCIStepBody)(NSArray * args, id userInfo);

@interface CCIStepDefinition : NSObject<NSCopying>

@property NSString * regexString;
@property NSString * type;
@property NSArray * matchedValues;
@property (nonatomic, copy) CCIStepBody body;

+ (instancetype)definitionWithType:(NSString *)type regexString:(NSString *)regexString implementationBody:(CCIStepBody)body;
@end
