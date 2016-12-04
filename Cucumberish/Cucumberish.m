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
#import "CCIScenarioDefinition.h"
#import "CCIHock.h"
#import "CCIAroundHock.h"



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


@property (nonatomic, assign) NSInteger scenariosRun;
@property (nonatomic, assign) NSInteger scenarioCount;

@property (nonatomic, strong) NSBundle * containerBundle;

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
#ifdef SRC_ROOT
    self.testTargetSrcRoot = SRC_ROOT;
    //Clean up unwanted /Pods path caused by cocoa pods
    if([self.testTargetSrcRoot hasSuffix:@"/Pods"]){
        self.testTargetSrcRoot = [self.testTargetSrcRoot stringByReplacingCharactersInRange:NSMakeRange(self.testTargetSrcRoot.length - 5, 5) withString:@""];
    }
#endif
    return self;
}


- (Cucumberish *)parserFeaturesInDirectory:(NSString *)directory fromBundle:(NSBundle *)bundle includeTags:(NSArray<NSString *> *)includeTags excludeTags:(NSArray<NSString *> *)excludeTags
{
    NSArray * featureFiles = [bundle URLsForResourcesWithExtension:@".feature" subdirectory:directory];
    self.containerBundle = bundle;

    [[CCIFeaturesManager instance] parseFeatureFiles:featureFiles bundle:bundle withTags:includeTags execludeFeaturesWithTags:excludeTags];
 
    return self;
}

- (Cucumberish *)parserFeaturesInDirectory:(NSString *)featuresDirectory includeTags:(NSArray<NSString *> *)tags excludeTags:(NSArray<NSString *> *)excludedTags
{
    [self parserFeaturesInDirectory:featuresDirectory
                         fromBundle:[NSBundle bundleForClass:[Cucumberish class]]
                        includeTags:tags
                        excludeTags:excludedTags];
    return self;
}

+ (void)executeFeaturesInDirectory:(NSString *)featuresDirectory includeTags:(NSArray *)tags excludeTags:(NSArray *)excludedTags
{
    [[[Cucumberish instance] parserFeaturesInDirectory:featuresDirectory
                                          includeTags:tags
                                          excludeTags:excludedTags] beginExecution];
}

+ (void)executeFeaturesInDirectory:(NSString *)featuresDirectory fromBundle:(NSBundle *)bundle includeTags:(NSArray *)tags excludeTags:(NSArray *)excludedTags
{
    [[[Cucumberish instance] parserFeaturesInDirectory:featuresDirectory
                                            fromBundle:bundle
                                           includeTags:tags
                                           excludeTags:excludedTags] beginExecution];
}

- (void)beginExecution
{
    
    for(CCIFeature * feature in [[CCIFeaturesManager instance] features]){
        Class featureClass = [Cucumberish featureTestCaseClass:feature];
        [[CCIFeaturesManager instance] setClass:featureClass forFeature:feature];
        [Cucumberish swizzleTestInvocationsImplementationForClass:featureClass];
        [Cucumberish swizzleFailureRecordingImplementationForClass:featureClass];
        [Cucumberish swizzleTestCaseWithSelectorImplementationForClass:featureClass];
    }
}

#pragma mark - Manage hocks
/**
 Adds an after hock to the after hocks chain in LIFO order.
 @param hock the after hock to be registerd
 */
- (void)addAfterHock:(CCIHock *)hock
{
    [self.afterHocks insertObject:hock atIndex:0];
}
/**
 Adds a before hock to the before hocks chain in FIFO order.
 @param hock the before hock to be registerd
 */
- (void)addBeforeHock:(CCIHock *)hock
{
    [self.beforeHocks addObject:hock];
}

/**
 Adds an around hock to the around hocks chain in FIFO order.
 @param hock the before hock to be registerd
 */
- (void)addAroundHock:(CCIAroundHock *)hock
{
    [self.aroundHocks addObject:hock];
}

/**
 Executes all the hocks that matches tags with the passed scenario.
 Hocks may optionally be tagged, if an hock is tagged, then it will only be executed if the scenario has a matching tag.
 
 @param hocks array of CCIHock to be executed
 @param scenario the scenario that will be passed to each matching hocks.
 */
 
- (void)executeMatchingHocksInHocks:(NSArray<CCIHock *> *)hocks forScenario:(CCIScenarioDefinition *)scenario
{
    for(CCIHock * hock in hocks){
        if(hock.tags.count > 0){
            if(scenario.tags.count > 0){
                for (NSString * tag in scenario.tags) {
                    if([hock.tags containsObject:tag]){
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


/**
 Executes all the before hocks that matches tags with the passed scenario.
 Hocks may optionally be tagged, if an hock is tagged, then it will only be executed if the scenario has a matching tag.
 
 @param scenario the scenario that will be passed to each matching hocks.
 */
- (void)executeBeforeHocksWithScenario:(CCIScenarioDefinition *)scenario
{
    [self executeMatchingHocksInHocks:self.beforeHocks forScenario:scenario];
}

/**
 Executes all the after hocks that matches tags with the passed scenario.
 Hocks may optionally be tagged, if an hock is tagged, then it will only be executed if the scenario has a matching tag.
 
 @param scenario the scenario that will be passed to each matching hocks.
 */
- (void)executeAfterHocksWithScenario:(CCIScenarioDefinition *)scenario
{
    [self executeMatchingHocksInHocks:self.afterHocks forScenario:scenario];
}

/**
 Executes all the around hocks that matches tags with the passed scenario.
 Hocks may optionally be tagged, if an hock is tagged, then it will only be executed if the scenario has a matching tag.
 
 @param scenario the scenario that will be passed to each matching hocks.
 @param executionBlock a block that when called, will execute the scenario. Around hocks are supposed to determine when this block will be executed.
 */
- (void)executeAroundHocksWithScenario:(CCIScenarioDefinition *)scenario executionBlock:(void(^)(void))executionBlock
{
    
    void(^executionChain)(void) = NULL;
    if(scenario.tags.count > 0){
        for(CCIAroundHock * around in self.aroundHocks){
            for (NSString * tag in scenario.tags) {
                if([around.tags containsObject:tag]){
                    if(executionChain == NULL){
                        executionChain = ^{
                            around.block(scenario, executionBlock);
                        };
                    }else{
                        executionChain = ^{
                            around.block(scenario, executionChain);
                        };
                    }
                    
                }
            }
        }
    }
    
    
    if(executionChain != NULL){
        executionChain();
    }else{
        executionBlock();
        
    }
}


#pragma mark - Runtime hacks

+ (void)swizzleOrignalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector originalClass:(Class)originalClass targetClass:(Class)targetClass classMethod:(BOOL)classMethod
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
    [Cucumberish swizzleOrignalSelector:originalSelector swizzledSelector:swizzledSelector originalClass:class targetClass:[Cucumberish class] classMethod:NO];
}



+ (void)swizzleTestInvocationsImplementationForClass:(Class)class
{
    SEL originalSelector = @selector(testInvocations);
    SEL swizzledSelector = @selector(cucumberish_testInvocations);
    [Cucumberish swizzleOrignalSelector:originalSelector swizzledSelector:swizzledSelector originalClass:class targetClass:[Cucumberish class] classMethod:YES];
}
+ (void)swizzleTestCaseWithSelectorImplementationForClass:(Class)class
{
    //cucumberish_testCaseWithSelector
    SEL originalSelector = @selector(testCaseWithSelector:);
    SEL swizzledSelector = @selector(cucumberish_testCaseWithSelector:);
    [Cucumberish swizzleOrignalSelector:originalSelector swizzledSelector:swizzledSelector originalClass:class targetClass:[Cucumberish class] classMethod:YES];
}

+ (NSString *)exampleScenarioNameForScenarioName:(NSString *)scenarioName exampleAtIndex:(NSInteger)index
{
    return [scenarioName stringByAppendingFormat:@" Example %lu", (unsigned long)(index + 1)];
}
+ (NSInvocation *)invocationForScenarioOutline:(CCIScenarioDefinition *)outline exampleIndex:(NSInteger)index feature:(CCIFeature *)feature featureClass:(Class)featureClass
{
    //Scenario for each body
    CCIScenarioDefinition * scenario = [outline copy];
    scenario.name = [self exampleScenarioNameForScenarioName:scenario.name exampleAtIndex:index];
    scenario.keyword = (NSString *)kScenarioOutlineKeyword;
    scenario.examples = nil;
    CCIExample * example = outline.examples.firstObject;
    for(NSString * variable in example.exampleData.allKeys){
        NSString * replacement = example.exampleData[variable][index];
        //now loop on each step in the scenario to replace the place holders with their values
        for(CCIStep * step in scenario.steps){
            NSString * placeHolder = [NSString stringWithFormat:@"<%@>", variable];
            step.text = [step.text stringByReplacingOccurrencesOfString:placeHolder withString:replacement];
            if (step.argument.rows) {
                NSMutableArray *modifiedRows = [NSMutableArray arrayWithCapacity:step.argument.rows.count];
                for (NSArray *row in step.argument.rows) {
                    NSMutableArray *array = [row mutableCopy];
                    [row enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([value isEqualToString:placeHolder]){
                            array[idx] = replacement;
                        }
                    }];
                    [modifiedRows addObject:array];
                }
                step.argument.rows = modifiedRows;
            }
        }
    }
    
    return [self invocationForScenario:scenario feature:feature featureClass:featureClass];
}

+ (NSArray<NSInvocation *> *)invocationsForScenarioOutline:(CCIScenarioDefinition *)outline feature:(CCIFeature *)feature featureClass:(Class)featureClass
{
    NSMutableArray<NSInvocation *> * invocations = [NSMutableArray new];
    for(CCIExample * example in outline.examples){
        
        //Loop on the example bod(y|ies)
        NSUInteger numberOfIndexes = [(NSArray *)example.exampleData[example.exampleData.allKeys.firstObject] count];
        for(int index = 0; index < numberOfIndexes; index++){
            
            NSInvocation * inv = [self invocationForScenarioOutline:outline exampleIndex:index  feature:feature featureClass:featureClass];
            
            [invocations addObject:inv];
            [Cucumberish instance].scenarioCount++;
        }
    }
    
    return invocations;
}

+ (Class)featureTestCaseClass:(CCIFeature *)feature
{
    //Prefix it with CCI to avoit any name collision
    //Prefix it with CCI to avoit any name collision
    NSString * className = [@"CCI " stringByAppendingString:feature.name];
    if(![[Cucumberish instance] prettyNamesAllowed]){
        className = [@"CCI_" stringByAppendingString:[feature.name camleCaseStringWithFirstUppercaseCharacter:YES]];
    }
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

+ (NSInvocation *)invocationForScenario:(CCIScenarioDefinition *)scenario feature:(CCIFeature *)feature featureClass:(Class)klass
{
    NSString * methodName = scenario.name;
    
    if(![[Cucumberish instance] prettyNamesAllowed]){
        methodName = [methodName camleCaseStringWithFirstUppercaseCharacter:NO];
    }
    SEL sel = NSSelectorFromString(methodName);
    
    //Prefered to forward the implementation to a C function instead of Objective-C method, to avoid confusion with the type of "self" object that is being to the implementation
    class_addMethod(klass, sel, (IMP)executeScenario, [@"v@:@:@" UTF8String]);
    
    NSMethodSignature *signature = [klass instanceMethodSignatureForSelector:sel];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation setSelector:sel];
    
    
    [invocation setArgument:&scenario atIndex:2];
    [invocation setArgument:&feature atIndex:3];
    [invocation retainArguments];
    return invocation;
}


#pragma mark - Swizzled methods


+ (nullable XCTestCase *)cucumberish_testCaseWithSelector:(SEL)selector
{
    CCIFeature * feature = [[CCIFeaturesManager instance] getFeatureForClass:[self class]];
    XCTestCase * invocationTest;
    
    for(CCIScenarioDefinition * s in feature.scenarioDefinitions){
        NSString * scenarioName = NSStringFromSelector(selector);
        if ([s.name isEqualToString:scenarioName]){
            NSInvocation * inv = [Cucumberish invocationForScenario:s feature:feature featureClass:[self class]];
            invocationTest =  [[self alloc] initWithInvocation:inv];
            break;
        }else if([s.keyword isEqualToString:(NSString *)kScenarioOutlineKeyword]){\
            NSInteger exampleIndex = [[scenarioName substringFromIndex:scenarioName.length - 2] integerValue] - 1;
            NSString * scenarioOutlineName = [Cucumberish exampleScenarioNameForScenarioName:s.name exampleAtIndex:exampleIndex];
            if([scenarioName isEqualToString:scenarioOutlineName]){
                NSInvocation * inv = [Cucumberish invocationForScenarioOutline:s exampleIndex:exampleIndex feature:feature featureClass:[self class]];
                invocationTest =  [[self alloc] initWithInvocation:inv];
                break;
            }
        }
    }
    return invocationTest;
}

/**
 Swizzled method, inside its implementation @b self does not refer to Cucumberish class.
 Records a failure in the execution of the test and is used by all test assertions.
 
 @param description The description of the failure being reported.
 
 @param filePath The file path to the source file where the failure being reported was encountered.
 @param lineNumber The line number in the source file at filePath where the failure being reported was encountered.
 
 @param expected YES if the failure being reported was the result of a failed assertion, NO if it was the result of an uncaught exception.
 */

+ (void)cucumberish_recordFailureWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber expected:(BOOL)expected
{
    //If exception already thrown and handled by executeSteps function, then report it immediately.
    if([filePath hasSuffix:@".feature"]){
        [self cucumberish_recordFailureWithDescription:description inFile:filePath atLine:lineNumber expected:expected];
    }else{
        //Throw the exception so proper error report takes place.
        throwCucumberishException(description);
    }
    
}

+ (NSArray <NSInvocation *> *)cucumberish_testInvocations
{
    NSMutableArray<NSInvocation *> * invocations = [NSMutableArray new];
    
    CCIFeature * feature = [[CCIFeaturesManager instance] getFeatureForClass:self];
    
    for (CCIScenarioDefinition * scenario in feature.scenarioDefinitions) {
        
        if([scenario.keyword isEqualToString:(NSString *)kScenarioOutlineKeyword]){
            
            NSArray<NSInvocation *> * invs = [Cucumberish invocationsForScenarioOutline:scenario feature:feature featureClass:self];
            [invocations addObjectsFromArray:invs];
        }else{
            if([scenario.keyword isEqualToString:(NSString *)kBackgroundKeyword]){
                //Do not add a scenario for a background steps
                feature.background = (CCIBackground *)scenario;
                continue;
            }
            [invocations addObject:[Cucumberish invocationForScenario:scenario feature:feature featureClass:self]];
            [Cucumberish instance].scenarioCount++;
        }
        
    }
    
    CCIFeature * lastFeature = [CCIFeaturesManager instance].features.lastObject;
    if([Cucumberish instance].fixMissingLastScenario && feature == lastFeature){
        CCIScenarioDefinition * cleanupScenario = [[CCIScenarioDefinition alloc] init];
        cleanupScenario.name = @"cucumberishCleanupScenario";
        [invocations addObject:[Cucumberish invocationForScenario:cleanupScenario feature:lastFeature featureClass:self]];
        [Cucumberish instance].scenarioCount++;
    }
    
    
    return invocations;
}


@end


#pragma mark - C Functions

void executeScenario(XCTestCase * self, SEL _cmd, CCIScenarioDefinition * scenario, CCIFeature * feature)
{
    
    self.continueAfterFailure = YES;
    if([Cucumberish instance].scenariosRun == 0 && [Cucumberish instance].beforeStartHock){
        [Cucumberish instance].beforeStartHock();
    }
    [[Cucumberish instance] executeBeforeHocksWithScenario:scenario];
    if(feature.background != nil && scenario.steps.count > 0){
        executeSteps(self, feature.background.steps, feature.background);
    }
    
    [[Cucumberish instance] executeAroundHocksWithScenario:scenario executionBlock:^{
       executeSteps(self, scenario.steps, scenario);
    }];
    [Cucumberish instance].scenariosRun++;
    [[Cucumberish instance] executeAfterHocksWithScenario:scenario];
    
    if([Cucumberish instance].scenariosRun == [Cucumberish instance].scenarioCount && [Cucumberish instance].afterFinishHock){
        [Cucumberish instance].afterFinishHock();
    }
}

void executeSteps(XCTestCase * testCase, NSArray * steps, id parentScenario)
{
    
    NSString * targetName = [[Cucumberish instance] testTargetFolderName] ? : [[[Cucumberish instance] containerBundle] infoDictionary][@"CFBundleName"];
    
    for (CCIStep * step in steps) {
        
        @try {
            [[CCIStepsManager instance] executeStep:step inTestCase:testCase];
        }
        @catch (CCIExeption *exception) {
            NSString * filePath = [NSString stringWithFormat:@"%@/%@%@", [Cucumberish instance].testTargetSrcRoot, targetName, step.location.filePath];
            [testCase recordFailureWithDescription:exception.reason inFile:filePath atLine:step.location.line expected:YES];
            if([parentScenario isKindOfClass:[CCIScenarioDefinition class]]){
                CCIScenarioDefinition * scenario = (CCIScenarioDefinition *)parentScenario;
                if(step.keyword.length > 0){
                    NSLog(@"Step: \"%@ %@\" failed", step.keyword, step.text);
                }
                step.status = CCIStepStatusFailed;
                scenario.success = NO;
                scenario.failureReason = exception.reason;
            }
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

void CCISAssert(BOOL expression, NSString * failureMessage)
{
    CCIAssert(expression, failureMessage);
}

void throwCucumberishException(NSString *reason, ...)
{
    va_list args;
    va_start(args, reason);
    NSString *description = [[NSString alloc] initWithFormat:reason arguments:args];
    va_end(args);
    [[CCIExeption exceptionWithName:@"CCIException" reason:description userInfo:nil] raise];
}

void SThrowCucumberishException(NSString * reason)
{
    throwCucumberishException(reason);
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




