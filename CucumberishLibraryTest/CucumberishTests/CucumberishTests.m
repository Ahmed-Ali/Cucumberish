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
#import "CCIJSONDumper.h"


@interface CucumberishTester : NSObject

@property NSMutableString *output;
@property NSMutableString *hooksOutput;

@end

@implementation CucumberishTester

@synthesize output = output;
@synthesize hooksOutput = hooksOutput;

+ (void)prepare
{
	[[Cucumberish instance] setPrettyNamesAllowed:YES];
	CucumberishTester * tester = [self new];
	tester.output = [NSMutableString string];
    tester.hooksOutput = [NSMutableString string];
	[tester defineStepsAndHocks];
}

+ (void)assertOutput:(NSString *)output isEqualToExpectedOutputInFile:(NSString *)expectedOutputFilename
{
    //Compare the whole output and see if it is as expected
    NSBundle * bundle = [NSBundle bundleForClass:[CucumberishTester class]];
    NSString * expectedOutputFile = [bundle pathForResource:expectedOutputFilename ofType:@"output"];
    NSError * error;
    NSString * expectedOutput = [[NSString stringWithContentsOfFile:expectedOutputFile encoding:NSUTF8StringEncoding error:&error] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * finalOutput = [output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSAssert(error == nil, @"Could not load the expected output file");

    NSAssert([finalOutput isEqualToString:expectedOutput], @"Acutal execution is different than expected exection:\nActual:\n%@\n=======\nExpected:\n%@", finalOutput, expectedOutput);
}

- (void)defineStepsAndHocks
{
	afterFinish(^{
		[self validateParsedContent];
		[self validateExecutionOutput];
        [self validateHooksOutput];
		[self validateRegisteredClassesAndMethods];
        
        [self validateJsonOutputDefaultDirectory];
        [self validateJsonOutputCustomDirectory];
	});

    around(^(CCIScenarioDefinition *scenario, void (^scenarioExectionBlock)(void)) {
        [hooksOutput appendFormat:@"Around all scenarios: Start\n"];
        scenarioExectionBlock();
        [hooksOutput appendFormat:@"Around all scenarios: End\n"];
    });

    aroundTagged(@[@"activity"], ^(CCIScenarioDefinition *scenario, void (^scenarioExectionBlock)(void)) {
        [hooksOutput appendFormat:@"Around @activity scenario: Start\n"];
        scenarioExectionBlock();
        [hooksOutput appendFormat:@"Around @activity scenarios: End\n"];
    });

    aroundTagged(@[@"history"], ^(CCIScenarioDefinition *scenario, void (^scenarioExectionBlock)(void)) {
        [hooksOutput appendFormat:@"Around @history scenario: Start\n"];
        scenarioExectionBlock();
        [hooksOutput appendFormat:@"Around @history scenarios: End\n"];
    });

    aroundTagged(@[@"profile"], ^(CCIScenarioDefinition *scenario, void (^scenarioExectionBlock)(void)) {
        [hooksOutput appendFormat:@"Around @profile scenario: Start\n"];
        scenarioExectionBlock();
        [hooksOutput appendFormat:@"Around @profile scenarios: End\n"];
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
    [CucumberishTester assertOutput:output isEqualToExpectedOutputInFile:@"expected_execution"];
}

- (void)validateHooksOutput
{
    [CucumberishTester assertOutput:hooksOutput isEqualToExpectedOutputInFile:@"expected_hooks"];
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

- (void)validateJsonOutputDefaultDirectory
{
    NSString * fileName = @"CucumberishResults-testOutput";
    NSString * jsonFile = [CCIJSONDumper writeJSONToFile:fileName
                       forFeatures: [[CCIFeaturesManager instance] features]];
    
    NSAssert( [jsonFile containsString:@"/Documents"], @"Default data directory not set correctly");
    
    NSError * error;
    
    [[NSFileManager defaultManager] removeItemAtPath:jsonFile
                                               error:&error];
    
    NSAssert(error == nil, @"%@%@", @"Could not delete file: ", error.description);

}

- (void)validateJsonOutputCustomDirectory
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * fileName = @"CucumberishResults-testOutput";
    
    NSBundle * bundle = [NSBundle bundleForClass:[CucumberishTester class]];
    NSString * customDirectory =  [[bundle bundlePath] stringByAppendingPathComponent: @"/testData"];
    NSString * jsonFile = [CCIJSONDumper writeJSONToFile:fileName
                                             inDirectory: customDirectory
                                             forFeatures: [[CCIFeaturesManager instance] features]];
    
    NSAssert( [jsonFile containsString:customDirectory], @"Custom directory not set correctly");
    
    NSError * error;
    
    [fileManager removeItemAtPath:jsonFile
                    error:&error];
    NSAssert(error == nil, @"%@%@", @"Could not delete file: ", error.description);
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

