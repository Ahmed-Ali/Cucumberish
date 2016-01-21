//
//  CCIExecution.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 21/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "CCIExecution.h"

@implementation CCIExecution
+ (instancetype)testCase:(XCTestCase *)testCase feature:(CCIFeature *)feature scenario:(CCIScenarioDefinition *)scenario step:(CCIStep *)step
{
    CCIExecution * instance = [[CCIExecution alloc] init];
    instance.testCase = testCase;
    instance.feature = feature;
    instance.scenario = scenario;
    instance.step = step;
    return instance;
}
@end
