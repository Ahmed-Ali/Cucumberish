//
//  Cucumberish.m
//
//  Created by Ahmed Ali on 03/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

#import "Cucumberish.h"
#import "CCIFeature.h"
#import "CCIFeaturesManager.h"
#import "CCIStepsManager.h"
#import "NSString+Formatter.h"
#import "CCIStepDefinition.h"


#ifndef SRC_ROOT
#define SRC_ROOT ""
#endif
#define STRINGFY(StringConst) #StringConst
#define STRINGFY2(StringConst) STRINGFY(StringConst)
#define SRCROOT @ STRINGFY2(SRC_ROOT)

@interface CCIExeption : NSException @end
@implementation CCIExeption @end

OBJC_EXTERN void executeScenario(XCTestCase * self, SEL _cmd, CCIScenarioDefinition * scenario, CCIFeature * feature);
OBJC_EXTERN void executeSteps(XCTestCase * testCase, NSArray * steps, id parentScenario);
OBJC_EXTERN NSString * stepDefinitionLineForStep(CCIStep * step);

@interface Cucumberish()
@property (nonatomic, copy) void(^beforeStartHock)(void);
@property (nonatomic, copy) void(^afterFinishHock)(void);

@property (nonatomic, strong) NSMutableArray<CCIHock *> * beforeHocks;
@property (nonatomic, strong) NSMutableArray<CCIHock *> * afterHocks;
@property (nonatomic, strong) NSMutableArray<CCIAroundHock *> * aroundHocks;

@end
@implementation Cucumberish

+ (instancetype)instance {
    static Cucumberish * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Cucumberish alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    self.fixMissingLastScenario = NO;
    
    self.beforeHocks = [NSMutableArray array];
    self.afterHocks = [NSMutableArray array];
    self.aroundHocks = [NSMutableArray array];
    return self;
}



- (Cucumberish *)parserFeaturesInDirectory:(NSString *)featuresDirectory featureTags:(NSArray *)tags
{
    NSString * featuresPath = [[[NSBundle bundleForClass:[Cucumberish class]] resourcePath] stringByAppendingPathComponent:featuresDirectory];
    
    NSArray * featureFiles = [[NSBundle bundleWithPath:featuresPath] URLsForResourcesWithExtension:@".feature" subdirectory:nil];
    [[CCIFeaturesManager instance] parseFeatureFiles:featureFiles withTags:tags];
    return self;
}


- (void)beginExecution
{
    for(CCIFeature * feature in [[CCIFeaturesManager instance] features]){
        Class featureClass = [Cucumberish featureTestCaseClass:feature];
        [[CCIFeaturesManager instance] setClass:featureClass forFeature:feature];
        [Cucumberish swizzleDefaultSuiteImplementationForClass:featureClass];
        [Cucumberish swizzleFailureRecordingImplementationForClass:featureClass];
    }
}

#pragma mark - Manage hocks

- (void)addAfterHock:(CCIHock *)hock
{
    [self.afterHocks insertObject:hock atIndex:0];
}

- (void)addBeforeHock:(CCIHock *)hock
{
    [self.beforeHocks addObject:hock];
}

- (void)addAroundHock:(CCIAroundHock *)hock
{
    [self.aroundHocks addObject:hock];
}

- (void)executeMatchingHocksInHocks:(NSArray<CCIHock *> *)hocks forScenario:(CCIScenarioDefinition *)scenario
{
    for(CCIHock * hock in hocks){
        if(hock.tags.count > 0){
            if(scenario.tags.count > 0){
                for (CCITag * tag in scenario.tags) {
                    if([hock.tags containsObject:tag.name]){
                        hock.block(scenario);
                        break;
                    }
                }
            }
        }else{
            hock.block(scenario);
        }
    }
}



- (void)executeBeforeHocksWithScenario:(CCIScenarioDefinition *)scenario
{
    [self executeMatchingHocksInHocks:self.beforeHocks forScenario:scenario];
}


- (void)executeAfterHocksWithScenario:(CCIScenarioDefinition *)scenario
{
    [self executeMatchingHocksInHocks:self.afterHocks forScenario:scenario];
}

- (void)executeAroundHocksWithScenario:(CCIScenarioDefinition *)scenario feature:(CCIFeature *)feature executionBlock:(void(^)(void))executionBlock
{
    
    void(^executionTree)(void) = NULL;
    if(scenario.tags.count > 0){
        for(CCIAroundHock * around in self.aroundHocks){
            for (CCITag * tag in scenario.tags) {
                if([around.tags containsObject:tag.name]){
                    //Only first match will have the scenario execution block
                    //Any additional matches, will contain the block that calls tha previous match...
                    //Example if three matches are found:
                    //Third Around Match
                    //  Block = A call to Second Around Match
                    //      Second Around Match
                    //          Block = A call to First Aroun Match
                    //              First Around Match
                    //                  Block = A call Scenario Exection Block
                    if(executionTree == NULL){
                        executionTree = ^{
                            around.block(scenario, executionBlock);
                        };
                    }else{
                        executionTree = ^{
                            around.block(scenario, executionTree);
                        };
                    }
                    
                }
            }
        }
    }
    
    
    if(executionTree != NULL){
        executionTree();
    }else{
        executionBlock();
        
    }
}

#pragma mark - Runtime hacks

+ (void)swizzleOrignalSelect:(SEL)originalSelector swizzledSelect:(SEL)swizzledSelector originalClass:(Class)originalClass targetClass:(Class)targetClass classMethod:(BOOL)classMethod
{
    Class class = classMethod ? object_getClass((id)originalClass) : originalClass;
    Method originalMethod = nil;
    if(classMethod){
        originalMethod = class_getClassMethod(class, originalSelector);
    }else{
        originalMethod = class_getInstanceMethod(class, originalSelector);
    }
    Method swizzledMethod = class_getClassMethod(targetClass, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
+ (void)swizzleFailureRecordingImplementationForClass:(Class)class
{
    SEL originalSelector = @selector(recordFailureWithDescription:inFile:atLine:expected:);
    SEL swizzledSelector = @selector(cucumberish_recordFailureWithDescription:inFile:atLine:expected:);
    [Cucumberish swizzleOrignalSelect:originalSelector swizzledSelect:swizzledSelector originalClass:class targetClass:self classMethod:NO];
}

+ (void)cucumberish_recordFailureWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber expected:(BOOL)expected
{
    if([filePath hasSuffix:@".feature"]){
        [self cucumberish_recordFailureWithDescription:description inFile:filePath atLine:lineNumber expected:expected];
    }else{
        throwCucumberishException(description);
    }
    
}

+ (void)swizzleDefaultSuiteImplementationForClass:(Class)class
{
    SEL originalSelector = @selector(defaultTestSuite);
    SEL swizzledSelector = @selector(cucumberish_defaultTestSuite);
    [Cucumberish swizzleOrignalSelect:originalSelector swizzledSelect:swizzledSelector originalClass:class targetClass:self classMethod:YES];
   
}

+ (XCTestSuite *)cucumberish_defaultTestSuite
{
    XCTestSuite * suite = [self cucumberish_defaultTestSuite];
    CCIFeature * feature = [[CCIFeaturesManager instance] getFeatureForClass:self];
    
    for (CCIScenarioDefinition * scenario in feature.scenarioDefinitions) {
        if([scenario.keyword isEqualToString:@"Scenario Outline"]){
            [Cucumberish createScenariosForScenarioOutline:scenario feature:feature class:self suite:suite];
        }else{
            XCTestCase  * testCase = [[self alloc] initWithInvocation:[Cucumberish invocationForScenario:scenario feature:feature class:self]];
            [suite addTest:testCase];
        }
        
    }
    CCIFeature * lastFeature = [CCIFeaturesManager instance].features.lastObject;
    if([Cucumberish instance].fixMissingLastScenario && feature == lastFeature){
        CCIScenarioDefinition * cleanupScenario = [[CCIScenarioDefinition alloc] init];
        cleanupScenario.name = @"cucumberishCleanupScenario";
        XCTestCase * finalCase = [[self alloc] initWithInvocation:[Cucumberish invocationForScenario:cleanupScenario feature:lastFeature class:self]];
        [suite addTest:finalCase];
    }
    
    return suite;
}

+ (void)createScenariosForScenarioOutline:(CCIScenarioDefinition *)outline feature:(CCIFeature *)feature class:(Class)klass suite:(XCTestSuite *)suite
{
    for(CCIExample * example in outline.examples){
        
        //Loop on the example bod(y|ies)
        
        for(int i = 0; i < example.tableBody.count; i++){
            CCITableBody * body = example.tableBody[i];
            //Scenario for each body
            CCIScenarioDefinition * scenario = [outline copy];
            scenario.name = [scenario.name stringByAppendingFormat:@"Example%lu", (unsigned long)(i + 1)];
            scenario.examples = nil;
            //Loop on body cells
            for(int j = 0; j < body.cells.count; j++){
                CCICell * valueCell = body.cells[j];
                CCICell * headerCell = example.tableHeader.cells[j];
                //now loop on each step in the scenario to replace the place holders with their values
                for(CCIStep * step in scenario.steps){
                    NSString * placeHolder = [NSString stringWithFormat:@"<%@>", headerCell.value];
                    step.text = [step.text stringByReplacingOccurrencesOfString:placeHolder withString:valueCell.value];
                }
            }
            XCTestCase  * testCase = [[klass alloc] initWithInvocation:[Cucumberish invocationForScenario:scenario feature:feature class:klass]];
            [suite addTest:testCase];
        }
        
        
        
    }
}

+ (Class)featureTestCaseClass:(CCIFeature *)feature
{
    NSString * className = [@"CCI_" stringByAppendingString:[feature.name camleCaseStringWithFirstUppercaseCharacter:YES]];
    Class featureClass = objc_allocateClassPair([XCTestCase class], [className UTF8String], 0);
    if(featureClass == nil){
        featureClass = NSClassFromString(className);
        NSUInteger availableClassesWithTheSameName = 1;
        while (featureClass == nil) {
            className = [className stringByAppendingFormat:@"%lu", (long unsigned)availableClassesWithTheSameName];
            featureClass = objc_allocateClassPair([XCTestCase class], [className UTF8String], 0);
        }
    }
    objc_registerClassPair(featureClass);
    return featureClass;
}

+ (NSInvocation *)invocationForScenario:(CCIScenarioDefinition *)scenraio feature:(CCIFeature *)feature class:(Class)klass
{
    SEL sel = NSSelectorFromString([scenraio.name camleCaseStringWithFirstUppercaseCharacter:NO]);
    
    //Prefered to forward the implementation to a C function instead of Objective-C method, to avoid confusion with the type of "self" object that is being to the implementation
    class_addMethod(klass, sel, (IMP)executeScenario, [@"v@:@:@" UTF8String]);
    
    NSMethodSignature *signature = [klass instanceMethodSignatureForSelector:sel];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation setSelector:sel];
    
    
    [invocation setArgument:&scenraio atIndex:2];
    [invocation setArgument:&feature atIndex:3];
    [invocation retainArguments];
    return invocation;
}

@end


#pragma mark - C Functions

void executeScenario(XCTestCase * self, SEL _cmd, CCIScenarioDefinition * scenario, CCIFeature * feature)
{
    
    self.continueAfterFailure = YES;
    if(feature == [CCIFeaturesManager instance].features.firstObject && scenario == feature.scenarioDefinitions.firstObject && [Cucumberish instance].beforeStartHock){
        [Cucumberish instance].beforeStartHock();
    }
    [[Cucumberish instance] executeBeforeHocksWithScenario:scenario];
    if(feature.background){
        executeSteps(self, feature.background.steps, feature.background);
    }
    
    [[Cucumberish instance] executeAroundHocksWithScenario:scenario feature:feature executionBlock:^{
       executeSteps(self, scenario.steps, scenario);
    }];
    [[Cucumberish instance] executeAfterHocksWithScenario:scenario];
    
    if(feature == [CCIFeaturesManager instance].features.lastObject && scenario == feature.scenarioDefinitions.lastObject && [Cucumberish instance].afterFinishHock){
        [Cucumberish instance].afterFinishHock();
    }
}

void executeSteps(XCTestCase * testCase, NSArray * steps, id parentScenario)
{
    
    NSString * targetName = [[NSBundle bundleForClass:[Cucumberish class]] infoDictionary][@"CFBundleName"];
    NSString * srcRoot = SRCROOT;
    //Clean up unwanted /Pods path caused by cocoa pods
    if([srcRoot hasSuffix:@"/Pods"]){
        srcRoot = [srcRoot stringByReplacingCharactersInRange:NSMakeRange(srcRoot.length - 5, 5) withString:@""];
    }
    
    for (CCIStep * step in steps) {
        
        @try {
            [[CCIStepsManager instance] executeStep:step];
        }
        @catch (CCIExeption *exception) {
            NSString * filePath = [NSString stringWithFormat:@"%@/%@%@", srcRoot, targetName, step.filePath];
            [testCase recordFailureWithDescription:exception.reason inFile:filePath atLine:step.location.line expected:YES];
            break;
        }
    }
}


void CCIAssert(BOOL expression, NSString * failureMessage, ...)
{
    if(!expression){
        va_list args;
        va_start(args, failureMessage);
        NSString *description = [[NSString alloc] initWithFormat:failureMessage arguments:args];
        va_end(args);
        throwCucumberishException(description);
    }
}

void throwCucumberishException(NSString *reason)
{
    [[CCIExeption exceptionWithName:@"CCIException" reason:reason userInfo:nil] raise];
}

#pragma mark - Hooks
void beforeStart(void(^beforeStartBlock)(void))
{
    [Cucumberish instance].beforeStartHock = beforeStartBlock;
}

void afterFinish(void(^afterFinishBlock)(void))
{
    [Cucumberish instance].afterFinishHock = afterFinishBlock;
}

void before(CCIScenarioHockBlock beforeEachBlock)
{
    [[Cucumberish instance] addBeforeHock:[CCIHock hockWithTags:nil block:beforeEachBlock]];
}

void after(CCIScenarioHockBlock afterEachBlock)
{
    [[Cucumberish instance] addAfterHock:[CCIHock hockWithTags:nil block:afterEachBlock]];
}

void beforeTagged(NSArray * tags, CCIScenarioHockBlock beforeTaggedBlock)
{
    [[Cucumberish instance] addBeforeHock:[CCIHock hockWithTags:tags block:beforeTaggedBlock]];
}

void afterTagged(NSArray * tags, CCIScenarioHockBlock afterTaggedBlock)
{
    [[Cucumberish instance] addAfterHock:[CCIHock hockWithTags:tags block:afterTaggedBlock]];
}

void around(NSArray * tags, CCIScenarioExecutionHockBlock aroundScenarioBlock)
{
    [[Cucumberish instance] addAroundHock:[CCIAroundHock hockWithTags:tags block:aroundScenarioBlock]];
}




