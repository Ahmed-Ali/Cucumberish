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

@property (nonatomic, strong) NSArray<NSString *> * tags;
@property (nonatomic, strong) NSArray<NSString *> * excludedTags;


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


- (Cucumberish *)parserFeaturesInDirectory:(NSString *)directory fromBundle:(NSBundle *)bundle includeTags:(NSArray<NSString *> *)includeTags excludeTags:(NSArray<NSString *> *)excludeTags
{
    NSArray * featureFiles = [bundle URLsForResourcesWithExtension:@".feature" subdirectory:directory];

    [[CCIFeaturesManager instance] parseFeatureFiles:featureFiles bundle:bundle withTags:includeTags execludeFeaturesWithTags:excludeTags];
    self.tags = includeTags;
    self.excludedTags = excludeTags;
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
        //This swizzling has to happen for each feature class...
        //If it is created on XCTestCase level, it will not work properly.
        [Cucumberish swizzleDefaultSuiteImplementationForClass:featureClass];
        [Cucumberish swizzleFailureRecordingImplementationForClass:featureClass];
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
 
 @param array of CCIHock to be executed
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

+ (void)swizzleDefaultSuiteImplementationForClass:(Class)class
{
    SEL originalSelector = @selector(defaultTestSuite);
    SEL swizzledSelector = @selector(cucumberish_defaultTestSuite);
    [Cucumberish swizzleOrignalSelector:originalSelector swizzledSelector:swizzledSelector originalClass:class targetClass:[Cucumberish class] classMethod:YES];
}




+ (void)createScenariosForScenarioOutline:(CCIScenarioDefinition *)outline feature:(CCIFeature *)feature class:(Class)klass suite:(XCTestSuite *)suite
{
    for(CCIExample * example in outline.examples){
        
        //Loop on the example bod(y|ies)
        NSUInteger numberOfRows = [(NSArray *)example.exampleData[example.exampleData.allKeys.firstObject] count];
        for(int i = 0; i < numberOfRows; i++){
            //Scenario for each body
            CCIScenarioDefinition * scenario = [outline copy];
            scenario.name = [scenario.name stringByAppendingFormat:@" Example %lu", (unsigned long)(i + 1)];
            scenario.examples = nil;
            for(NSString * variable in example.exampleData.allKeys){
                NSString * replacement = example.exampleData[variable][i];
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
            
            XCTestCase  * testCase = [[klass alloc] initWithInvocation:[Cucumberish invocationForScenario:scenario feature:feature class:klass]];
            [suite addTest:testCase];
        }
        
        
        
    }
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

+ (NSInvocation *)invocationForScenario:(CCIScenarioDefinition *)scenario feature:(CCIFeature *)feature class:(Class)klass
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

/**
 Swizzled method, inside its implementation @b self does not refer to Cucumberish class.
 @return a test suite containing test cases for all of the tests in the class.
 */

+ (XCTestSuite *)cucumberish_defaultTestSuite
{
    XCTestSuite * suite = [self cucumberish_defaultTestSuite];
    CCIFeature * feature = [[CCIFeaturesManager instance] getFeatureForClass:self];
    
    for (CCIScenarioDefinition * scenario in feature.scenarioDefinitions) {
        if(![[Cucumberish instance] shouldIncludeScenario:scenario]){
            continue;
        }
        if([scenario.keyword isEqualToString:@"Scenario Outline"]){
            [Cucumberish createScenariosForScenarioOutline:scenario feature:feature class:self suite:suite];
        }else{
            if([scenario.keyword isEqualToString:@"Background"]){
                //Do not add a scenario for a background steps
                feature.background = (CCIBackground *)scenario;
                continue;
            }
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

- (BOOL)shouldIncludeScenario:(CCIScenarioDefinition *)scenario
{
    BOOL shouldIncludeScenario = YES;
    if(![scenario.keyword isEqualToString:@"Background"]){
        if(self.tags.count > 0){
            shouldIncludeScenario = [self tags:scenario.tags intersectWithTags:self.tags]&& ![self tags:scenario.tags intersectWithTags:self.excludedTags];
        }else if(self.excludedTags.count > 0){
            shouldIncludeScenario = ![self tags:scenario.tags intersectWithTags:self.excludedTags];
        }
    }
    return shouldIncludeScenario;
}


- (BOOL)tags:(NSArray *)tags intersectWithTags:(NSArray *)intersectionTags
{
    BOOL intersect = NO;
    if(tags.count == 0 || intersectionTags.count == 0){
        return intersect;
    }
    for(NSString * tag in tags){
        if([intersectionTags containsObject:tag]){
            intersect = YES;
            break;
        }
    }
    return intersect;
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
    if(feature.background != nil && scenario.steps.count > 0){
        executeSteps(self, feature.background.steps, feature.background);
    }
    
    [[Cucumberish instance] executeAroundHocksWithScenario:scenario executionBlock:^{
       executeSteps(self, scenario.steps, scenario);
    }];
    [[Cucumberish instance] executeAfterHocksWithScenario:scenario];
    
    if(feature == [CCIFeaturesManager instance].features.lastObject && scenario == feature.scenarioDefinitions.lastObject && [Cucumberish instance].afterFinishHock){
        [Cucumberish instance].afterFinishHock();
    }
}

void executeSteps(XCTestCase * testCase, NSArray * steps, id parentScenario)
{
    
    NSString * targetName = [[Cucumberish instance] testTargetFolderName] ? : [[NSBundle bundleForClass:[Cucumberish class]] infoDictionary][@"CFBundleName"];
    NSString * srcRoot = SRC_ROOT;
    //Clean up unwanted /Pods path caused by cocoa pods
    if([srcRoot hasSuffix:@"/Pods"]){
        srcRoot = [srcRoot stringByReplacingCharactersInRange:NSMakeRange(srcRoot.length - 5, 5) withString:@""];
    }
    
    for (CCIStep * step in steps) {
        
        @try {
            [[CCIStepsManager instance] executeStep:step inTestCase:testCase];
        }
        @catch (CCIExeption *exception) {
            NSString * filePath = [NSString stringWithFormat:@"%@/%@%@", srcRoot, targetName, step.location.filePath];
            [testCase recordFailureWithDescription:exception.reason inFile:filePath atLine:step.location.line expected:YES];
            if([parentScenario isKindOfClass:[CCIScenarioDefinition class]]){
                CCIScenarioDefinition * scenario = (CCIScenarioDefinition *)parentScenario;
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




