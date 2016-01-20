//
//  CCIFeaturesManager.m
//  CucumberishExample
//
//  Created by Ahmed Ali on 02/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import "CCIFeaturesManager.h"
#import "GHParser+Extensions.h"
#import "NSObject+Dictionary.h"
#import "CCIFeature.h"
#import "CCIStepsManager.h"
#import "Cucumberish.h"
#import "CCIStepDefinition.h"

static CCIFeaturesManager * instance = nil;

@interface CCIFeaturesManager()

@property NSMutableDictionary * featureClassMap;

@end

@implementation CCIFeaturesManager
+ (instancetype)instance {
    
    @synchronized(self) {
        if(instance == nil){
            instance = [[CCIFeaturesManager alloc] init];
        }
    }
    return instance;
}


- (instancetype) init
{
    self = [super init];
    self.featureClassMap = [@{} mutableCopy];
    return self;
}
- (void)parseFeatureFiles:(NSArray *)featureFiles withTags:(NSArray *)tags
{
    NSMutableArray * parsedFeatures = [NSMutableArray array];
    
    
    GHParser * featureParser = [[GHParser alloc] init];
    for (NSURL * filePath in featureFiles) {
        NSString * content = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
        id result = [featureParser parseContent:content];
        
        if(result){
            NSMutableDictionary * featureData = [[result dictionary] mutableCopy];
            
            NSString * localPath = [[filePath.absoluteString stringByReplacingOccurrencesOfString:[[NSBundle bundleForClass:[self class]] bundlePath] withString:@""] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            
            featureData[@"filePath"] = localPath;
            CCIFeature * feature = [[CCIFeature alloc] initWithDictionary:featureData];
  
            
            if(tags == nil || tags.count == 0){
                [parsedFeatures addObject:feature];
            }else{
                for (CCITag * featureTag in feature.tags) {
                    if ([tags containsObject:featureTag.name]) {
                        [parsedFeatures addObject:feature];
                        break;
                    }
                }
            }
            
        }
    }
    
    self.features = parsedFeatures;
}



- (void)setClass:(Class)klass forFeature:(CCIFeature *)feature
{
    NSString * className = NSStringFromClass(klass);
    self.featureClassMap[className] = feature;
}

- (CCIFeature *)getFeatureForClass:(Class)klass
{
    NSString * className = NSStringFromClass(klass);
    return self.featureClassMap[className];
}

@end
