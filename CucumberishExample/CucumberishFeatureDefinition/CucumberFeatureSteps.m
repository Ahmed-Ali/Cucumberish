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

@implementation CucumberFeatureSteps


-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
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
        CCIAssert([CCIFeaturesManager instance].features.count == 1, @"Expected only one feature file");
        CCIFeature *feature = [CCIFeaturesManager instance].features[0];
        CCIAssert(feature.scenarioDefinitions.count == 2, @"Expected two scenarios, one for background one for the actual scenario");
        
        CCIScenarioDefinition *mainScenario = feature.scenarioDefinitions[1];
        
        NSArray *hashes = [userInfo[@"DataTable"] rowHashes];
        
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
}

-(BOOL)checkStep:(CCIStep*)step forKeyword:(NSString*)keyword
{
    if ([step.keyword isEqualToString:keyword] && step.status == CCIStepStatusPassed) {
        return YES;
    }
    return NO;
}

@end
