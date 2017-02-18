//
//  CucumberFeatureSteps.m
//  CucumberishExample
//
//  Created by David Siebecker on 7/26/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "CucumberFeatureSteps.h"
#import "Cucumberish.h"
#import "CCIFeaturesManager.h"
#import "CCIStepsManager.h"
#import "CCIFeature.h"
#import "NSArray+Hashes.h"
#import "CCIJSONDumper.h"

@interface CucumberFeatureSteps()

@property (nonatomic,strong) NSMutableDictionary* savedValues;
@property (nonatomic,strong) NSMutableArray* savedAStepValues;
@property (nonatomic,assign) BOOL exactMatchTriggered;
@property (nonatomic,assign) BOOL inexactMatchTriggered;
@property (nonatomic, strong) NSString* savedJSONFilePath;

@end

@implementation CucumberFeatureSteps


-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        _savedValues = [NSMutableDictionary dictionary];
        _savedAStepValues = [NSMutableArray array];
    }
    return self;
}

-(void)setup
{
    Given(@"a (.*) statement", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        
    });
    
    And(@"an (.*) statement", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        
    });
    
    When(@"a (.*) statement", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        
    });
    
    But(@"a (.*) statement", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        
    });
    
    Then(@"a (.*) statement", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        
    });
    
    When(@"cucumber is executed", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        //a do nothing step
    });
    
    Then(@"I see the following statements have been executed", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        CCIAssert([CCIFeaturesManager instance].features.count > 0, @"Expected at least one feature file");
        CCIFeature *feature = [CCIFeaturesManager instance].features[0];
        CCIAssert(feature.scenarioDefinitions.count == 2, @"Expected two scenarios, one for background one for the actual scenario");
        
        CCIScenarioDefinition *mainScenario = feature.scenarioDefinitions[1];
        
        NSArray *hashes = [userInfo[kDataTableKey] rowHashes];
        
        for (NSDictionary *dict in hashes) {
            if ([dict[@"statement"] isEqualToString:@"Background"]) {
                CCIScenarioDefinition *backgroundScenario = feature.scenarioDefinitions[0];
                CCIAssert(backgroundScenario.steps.count == 1, @"Expect one step in the background scenario");
                CCIAssert([backgroundScenario.steps[0] status] == CCIStepStatusPassed, @"Expected the background scenario to pass");
            } else {
                __block BOOL passed = NO;
                [mainScenario.steps enumerateObjectsUsingBlock:^(CCIStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    passed = [self checkStep:obj forKeyword:dict[@"statement"]];
                    if (passed) {
                        *stop = YES;
                    }
                }];
                CCIAssert(passed, @"Unable to find passed %@ step",dict[@"statement"]);
            }
            
        }
    });
    
    
    When(@"cucumber outputs the details of \"JSON Output\" to a JSON to a file", ^(NSArray<NSString *> *args, NSDictionary *userInfo){
        CCIAssert([CCIFeaturesManager instance].features.count > 0, @"Expected at least one feature file");
        NSUInteger index = [[[CCIFeaturesManager instance] features] indexOfObjectPassingTest:^BOOL(CCIFeature * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [[obj name] isEqualToString:@"JSON Output"];
        }];
        CCIAssert(index != NSNotFound, @"could not find the name %@", @"JSON Output");
        CCIFeature *feature = [[[CCIFeaturesManager instance] features] objectAtIndex:index];
        CCIAssert(feature != nil, @"Feature is nil");
        NSString* fileName= [[@"JSON Output" lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        
        self.savedJSONFilePath=[CCIJSONDumper writeJSONToFile:fileName forFeatures:@[feature]];
        CCIAssert([self.savedJSONFilePath hasSuffix:[NSString stringWithFormat:@"%@.json", fileName]],@"resulting file is not right it came out like this: %@", self.savedJSONFilePath);
        
        // CCIAssert([args.firstObject isEqualToString:feature.name], @"Wrong name %@", feature.name);
        
    });
    
    Then(@"I see the JSON contains the details of the \"JSON Output\" feature", ^(NSArray<NSString*> *args, NSDictionary *userInfo){
        
        //read the data from the file
        NSString* fileName= [[@"JSON Output" lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        CCIAssert([self.savedJSONFilePath hasSuffix:[NSString stringWithFormat:@"%@.json", fileName]],@"resulting file is not right it came out like this: %@", self.savedJSONFilePath);
        NSData* data = [NSMutableData dataWithContentsOfFile:self.savedJSONFilePath];
        CCIAssert([data length] > 0, @"The data was empty at file path %@", self.savedJSONFilePath);
        
        //parse the json into an array of dictionaries
        NSError * error= nil;
        NSArray<NSDictionary*> *parsedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        CCIAssert(error == nil, @"There was a parse error %@", error.localizedDescription);
        CCIAssert(parsedJSON != nil, @"The JSON Object is nil");
        CCIAssert([parsedJSON count] == 1, @"There are more than just the one feature in this JSON file in fact there are %d", [parsedJSON count]);
        
        
        
        
        //grab the feature we are verifying the JSON against
        CCIAssert([CCIFeaturesManager instance].features.count > 0, @"Expected at least one feature file");
        NSUInteger index = [[[CCIFeaturesManager instance] features] indexOfObjectPassingTest:^BOOL(CCIFeature * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [[obj name] isEqualToString:@"JSON Output"];
        }];
        CCIAssert(index != NSNotFound, @"could not find the name %@", @"JSON Output");
        CCIFeature *feature = [[[CCIFeaturesManager instance] features] objectAtIndex:index];
        CCIAssert(feature != nil, @"Feature is nil");
        
        //grab the feature dictionary we are verifying
        NSDictionary * featureDictionary= [parsedJSON firstObject];
        CCIAssert(featureDictionary != nil, @"The first JSON dictionary is nil");
        
        
        
        NSArray<NSDictionary*> * knownFeature=  @[
                                                  @{
                                                      @"uri" : @"/Features/5_json_output.feature",
                                                      @"id" : @"json-output",
                                                      @"elements" : @[
                                                              @{
                                                                  
                                                                  @"id" : @"json-output;json-output",
                                                                  @"steps" : @[
                                                                          @{
                                                                              @"result" : @{
                                                                                      @"status" : @"passed"
                                                                                      },
                                                                              @"line" : @13,
                                                                              @"name" : @"a Given statement",
                                                                              @"keyword" : @"Given"
                                                                              },
                                                                          @{
                                                                              @"result" : @{
                                                                                      @"status" : @"passed"
                                                                                      },
                                                                              @"line" : @14,
                                                                              @"name" : @"an And statement",
                                                                              @"keyword" : @"And"
                                                                              },
                                                                          @{
                                                                              @"result" : @{
                                                                                      @"status" : @"passed"
                                                                                      },
                                                                              @"line" : @15,
                                                                              @"name" : @"a When statement",
                                                                              @"keyword" : @"When"
                                                                              },
                                                                          @{
                                                                              @"result" : @{
                                                                                      @"status" : @"passed"
                                                                                      },
                                                                              @"line" : @16,
                                                                              @"name" : @"a But statement",
                                                                              @"keyword" : @"But"
                                                                              },
                                                                          @{
                                                                              @"result" : @{
                                                                                      @"status" : @"passed"
                                                                                      },
                                                                              @"line" : @17,
                                                                              @"name" : @"a Then statement",
                                                                              @"keyword" : @"Then"
                                                                              },
                                                                          @{
                                                                              @"result" : @{
                                                                                      @"status" : @"skipped"
                                                                                      },
                                                                              @"line" : @18,
                                                                              @"name" : @"cucumber outputs the details of \"JSON Output\" to a JSON to a file",
                                                                              @"keyword" : @"When"
                                                                              },
                                                                          @{
                                                                              @"result" : @{
                                                                                      @"status" : @"skipped"
                                                                                      },
                                                                              @"line" : @19,
                                                                              @"name" : @"I see the JSON contains the details of the \"JSON Output\" feature",
                                                                              @"keyword" : @"Then"
                                                                              }
                                                                          ],
                                                                  @"keyword" : @"Scenario",
                                                                  @"type" : @"scenario",
                                                                  @"line" : @12,
                                                                  @"name" : @"Json Output",
                                                                  @"description" : @""
                                                                  }
                                                              ],
                                                      @"name" : @"JSON Output",
                                                      @"description" : @"Cucumberish shall output JSON containing details of each feature file.\n\n* Given\n* When\n* Then\n* And\n* But\n* Background",
                                                      @"keyword" : @"Feature"
                                                      }
                                                  ];
        //do the validation
        CCIAssert([knownFeature isEqualToArray:parsedJSON], @"The json is not equal to the known feature");
        
        
        
        
    });
    
    
    Given(@"a table with examples", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        NSArray *hashes = [userInfo[@"DataTable"] rowHashes];
        for (NSDictionary *dict in hashes) {
            self.savedValues[@"option1"] = dict[@"option1"];
            self.savedValues[@"option2"] = dict[@"option2"];
            self.savedValues[@"option3"] = dict[@"option3"];
        }
    });
    
    Then(@"([A-Za-z0-9]+) value ([A-Za-z0-9]+) has been passed through", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        CCIAssert(self.savedValues[args[0]] != nil, @"Expected to have a saved key of @",args[0]);
        if (self.savedValues[args[0]]) {
            CCIAssert([self.savedValues[args[0]] isEqualToString:args[1]] != NO, @"Expected %@ to equal %@, got %@",args[0],args[1],self.savedValues[args[0]]);
        }
    });
    
    And(@"([A-Za-z0-9]+) value (.*) has been passed through", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        CCIAssert(self.savedValues[args[0]] != nil, @"Expected to have a saved key of @",args[0]);
        if (self.savedValues[args[0]]) {
            CCIAssert([self.savedValues[args[0]] isEqualToString:args[1]] != NO, @"Expected %@ to equal %@, got %@",args[0],args[1],self.savedValues[args[0]]);
        }
    });
    
    Match(@[@"Given",@"And"],@"^a step(?: has an optional match \"([a-z]+)\")?$", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        if (args.count == 0) {
            [self.savedAStepValues addObject:[NSNull null]];
        } else {
            [self.savedAStepValues addObject:args[0]];
        }
    });
    
    Match(@[@"Then",@"And"],@"the step \"a step\" had no match for the optional parameter", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        __block BOOL found = NO;
        for (id obj in self.savedAStepValues) {
            if ([obj isKindOfClass:[NSNull class]]) {
                found = YES;
            }
        }
        CCIAssert(found, @"Expected to find a NSNull, found @%",self.savedAStepValues);
    });
    
    Match(@[@"Then",@"And"],@"the step \"a step\" had \"([a-z]+)\" matched for the optional parameter", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        __block BOOL found = NO;
        for (id obj in self.savedAStepValues) {
            if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:args[0]]) {
                found = YES;
            }
        }
        CCIAssert(found, @"Expected to find a %@, found @%",args[0],self.savedAStepValues);
    });
    
    Given(@"^a step that matches beginning and end$", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        self.exactMatchTriggered = YES;
    });
    
    And(@"a step that just matches strings", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        self.inexactMatchTriggered = YES;
    });
    
    
    Then(@"the exact match passed", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        CCIAssert(self.exactMatchTriggered, @"Expected the exact match to be triggered");
    });
    
    And(@"the inexact match passed", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        CCIAssert(self.inexactMatchTriggered, @"Expected the inexact match to be triggered");
    });
    
    
}

-(BOOL)checkStep:(CCIStep*)step forKeyword:(NSString*)keyword
{
    if ([step.keyword isEqualToString:keyword] && step.status == CCIStepStatusPassed) {
        return YES;
    }
    return NO;
}

@end
