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

@interface CucumberFeatureSteps()

@property (nonatomic,strong) NSMutableDictionary* savedValues;
@property (nonatomic,strong) NSMutableArray* savedAStepValues;
@property (nonatomic,assign) BOOL exactMatchTriggered;
@property (nonatomic,assign) BOOL inexactMatchTriggered;

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
    
    Given(@"a table with examples", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        NSArray *hashes = [userInfo[@"DataTable"] rowHashes];
        for (NSDictionary *dict in hashes) {
            self.savedValues[@"option1"] = dict[@"option1"];
            self.savedValues[@"option2"] = dict[@"option2"];
        }
    });
    
    Then(@"([A-Za-z0-9]+) value ([A-Za-z0-9]+) has been passed through", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        CCIAssert(self.savedValues[args[0]] != nil, @"Expected to have a saved key of @",args[0]);
        if (self.savedValues[args[0]]) {
            CCIAssert([self.savedValues[args[0]] isEqualToString:args[1]] != NO, @"Expected %@ to equal %@, got %@",args[0],args[1],self.savedValues[args[0]]);
        }
    });

    And(@"([A-Za-z0-9]+) value ([A-Za-z0-9]+) has been passed through", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
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
