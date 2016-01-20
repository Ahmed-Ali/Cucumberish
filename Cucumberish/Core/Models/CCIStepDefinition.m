//
//  CCIStepDefinition.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 02/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "CCIStepDefinition.h"
#import "GHParser+Extensions.h"
#import "NSObject+Dictionary.h"
#import "CCIFeature.h"
#import "CCILocation.h"
#include <stdio.h>


@implementation CCIStepDefinition


+ (instancetype)definitionWithType:(NSString *)type regexString:(NSString *)regex implementationBody:(CCIStepBody)body
{
    CCIStepDefinition * definition = [CCIStepDefinition new];
    definition.type = type;
    definition.regexString = regex;
    definition.body = body;
    return definition;
}



- (NSString *)description
{
    return [NSString stringWithFormat:@"Definition type: %@, regexString: %@, matchedValues: %@", self.type, self.regexString, self.matchedValues];
}



#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    CCIStepDefinition * stepDefinition = [CCIStepDefinition definitionWithType:self.type regexString:self.regexString implementationBody:self.body];
    stepDefinition.matchedValues = self.matchedValues;

    return stepDefinition;
}
@end

