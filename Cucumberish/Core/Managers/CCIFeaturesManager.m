//
//  CCIFeaturesManager.m

//
//  Created by Ahmed Ali on 02/01/16.
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

#import "CCIFeaturesManager.h"
#import "GHParser+Extensions.h"
#import "NSObject+Dictionary.h"
#import "CCIFeature.h"
#import "CCIStepsManager.h"
#import "Cucumberish.h"
#import "CCIStepDefinition.h"



@interface CCIFeaturesManager()

@property NSMutableDictionary * featureClassMap;

@end

@implementation CCIFeaturesManager
+ (instancetype)instance {
    static CCIFeaturesManager * instance = nil;
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

- (void)parseFeatureFiles:(NSArray *)featureFiles bundle:(NSBundle *)bundle withTags:(NSArray *)tags execludeFeaturesWithTags:(NSArray *)execludedFeatures
{
    NSMutableArray * parsedFeatures = [NSMutableArray array];
    
    GHParser * featureParser = [[GHParser alloc] init];
    for (NSURL * filePath in featureFiles) {
        
        id result = [featureParser parse:filePath.path];
        
        if(result){
            NSMutableDictionary * featureData = [[result dictionary] mutableCopy];
            
            NSString * testBundlePath = [bundle bundlePath];
            NSString * localPath = [[[filePath.absoluteString stringByRemovingPercentEncoding]
                                     stringByReplacingOccurrencesOfString:testBundlePath withString:@""]
                                    stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            
            featureData[@"location"][@"filePath"] = localPath;
            CCIFeature * feature = [[CCIFeature alloc] initWithDictionary:featureData];
  
            
            if(tags.count == 0){
                //If we don't have specific tags, make sure we are not in the execluded tags
                if(execludedFeatures.count > 0 && feature.tags.count > 0){
                    if(![self featureTags:feature.tags intersectWithTags:execludedFeatures]){
                        [parsedFeatures addObject:feature];
                    }
                }else{
                    [parsedFeatures addObject:feature];
                }
                
            }else{
                //If one of the feature tag is in the allowed tags
                if([self featureTags:feature.tags intersectWithTags:tags]){
                    if(execludedFeatures.count > 0){
                        //Make sure that the feature doesn't contain execluded tags, and if so, execlude it...
                        if(![self featureTags:feature.tags intersectWithTags:execludedFeatures]){
                            [parsedFeatures addObject:feature];
                        }
                    }else{
                        [parsedFeatures addObject:feature];
                    }
                    
                }
            }
            
        }
    }
    
    _features = parsedFeatures;
}


- (BOOL)featureTags:(NSArray *)featureTags intersectWithTags:(NSArray *)tags
{
    BOOL intersect = NO;
    for(NSString * tag in featureTags){
        if([tags containsObject:tag]){
            intersect = YES;
            break;
        }
    }
    
    return intersect;
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
