//
//  CCIExecution.h
//  CucumberishExample
//
//  Created by Ahmed Ali on 21/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XCTestCase;
@class CCIFeature;
@class CCIScenarioDefinition;
@class CCIStep;

@interface CCIExecution : NSObject

@property (nonatomic, weak) XCTestCase * testCase;
@property (nonatomic, weak) CCIFeature * feature;
@property (nonatomic, weak) CCIScenarioDefinition * scenario;
@property (nonatomic, weak) CCIStep * step;

+ (instancetype)testCase:(XCTestCase *)testCase feature:(CCIFeature *)feature scenario:(CCIScenarioDefinition *)scenario step:(CCIStep *)step;
@end
