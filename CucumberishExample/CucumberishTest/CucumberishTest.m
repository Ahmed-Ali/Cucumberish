//
//  CucumberishTest.m
//  CucumberishTest
//
//  Created by Ahmed Ali on 06/02/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <XCTest/XCTest.h>


#import "Cucumberish.h"
#import "CCIScenarioDefinition.h"
#import "CCIFeaturesManager.h"
#import "CCIFeature.h"

@interface CucumberishTester : NSObject
@property NSMutableString * output;
@end

@implementation CucumberishTester
@synthesize output = output;

+ (void)prepare
{
    [[Cucumberish instance] setPrettyNamesAllowed:YES];
    CucumberishTester * tester = [self new];
    tester.output = [NSMutableString string];
    [tester defineStepsAndHocks];
}

- (void)defineStepsAndHocks
{
    afterFinish(^{
        [self validateParsedContent];
        [self validateExecutionOutput];
        [self validateRegisteredClassesAndMethods];
    });
    
    
    before(^(CCIScenarioDefinition *scenario) {
        [output appendFormat:@"Scenario : %@\n", scenario.name];
    });
    
    Given(@"(.*)", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        [output appendFormat:@"Given %@\n", args[0]];
    });
    
    When(@"(.*)", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        [output appendFormat:@"When %@\n", args[0]];
    });
    
    Then(@"(.*)", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        [output appendFormat:@"Then %@\n", args[0]];
    });
    
    And(@"(.*)", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        [output appendFormat:@"And %@\n", args[0]];
    });
    
    But(@"(.*)", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        [output appendFormat:@"But %@\n", args[0]];
    });
    
}

- (void)validateParsedContent
{
    NSArray * features = [[CCIFeaturesManager instance] features];
    NSMutableArray * featureDictionaries = [NSMutableArray array];
    for(CCIFeature * feature in features){
        
        [featureDictionaries addObject:[feature toDictionary]];
    }
    NSError * parsingError;
    NSData * data = [NSJSONSerialization dataWithJSONObject:featureDictionaries options:0 error:&parsingError];
    
    NSString * actualJsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSAssert(actualJsonString.length > 0, @"Could not convert parsed features into JSON string");
    NSBundle * bundle = [NSBundle bundleForClass:[CucumberishTester class]];
    NSString * expectedOutputFile = [bundle pathForResource:@"expected_json_output" ofType:@"json"];
    NSError * error;
    NSString * expectedOutput = [[NSString stringWithContentsOfFile:expectedOutputFile encoding:NSUTF8StringEncoding error:&error] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSAssert(error == nil, @"Could not load the expected output file");
    NSAssert([expectedOutput isEqualToString:actualJsonString], @"Acutal parsed JSON is different than expected JSON:\nActual:\n%@\n=======\nExpected:\n%@", actualJsonString, expectedOutput);
}

- (void)validateExecutionOutput
{
    //Compare the whole output and see if it is as expected
    NSBundle * bundle = [NSBundle bundleForClass:[CucumberishTester class]];
    NSString * expectedOutputFile = [bundle pathForResource:@"expected_execution" ofType:@"output"];
    NSError * error;
    NSString * expectedOutput = [[NSString stringWithContentsOfFile:expectedOutputFile encoding:NSUTF8StringEncoding error:&error] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * finalOutput = [output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSAssert(error == nil, @"Could not load the expected output file");
    NSAssert([expectedOutput isEqualToString:finalOutput], @"Acutal execution is different than expected exection:\nActual:\n%@\n=======\nExpected:\n%@", finalOutput, expectedOutput);
}

- (void)validateRegisteredClassesAndMethods
{
    NSBundle * bundle = [NSBundle bundleForClass:[CucumberishTester class]];
    NSString * jsonFile = [bundle pathForResource:@"expected_classes_and_methods" ofType:@"json"];
    NSError * error;
    NSString * jsonString = [[NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:&error] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSAssert(error == nil, @"Could not load expected features and scenarios file");
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * featuresDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSAssert(error == nil, @"Could not load expected features and json content");
    NSAssert(featuresDictionary.allKeys.count > 0, @"There is not features or scenarios to validate whether they are registered!");
    for(NSString * featureClassName in featuresDictionary.allKeys){
        Class featureClass = NSClassFromString(featureClassName);
        NSAssert(featureClass != nil, @"Could not find a registerd class for the feature class %@", featureClassName);
        NSArray * scenarioNames = featuresDictionary[featureClassName];
        for(NSString * scenarioMethodName in scenarioNames){
            BOOL methodExist = [featureClass instancesRespondToSelector:NSSelectorFromString(scenarioMethodName)];
            NSAssert(methodExist, @"Could not find scenario method: %@ in feature class: %@", scenarioMethodName, featureClassName);
        }
    }
}



@end



__attribute__((constructor))
void CucumberishInit()
{
    [CucumberishTester prepare];
    
    //Optional step, see the comment on this property for more information
    [Cucumberish instance].fixMissingLastScenario = YES;
    //Tell Cucumberish the name of your features folder and let it execute them for you...
    NSBundle * bundle = [NSBundle bundleForClass:[Cucumberish class]];
    [Cucumberish executeFeaturesInDirectory:@"Features" fromBundle:bundle includeTags:@[@"run"] excludeTags:@[@"skip"]];
}

