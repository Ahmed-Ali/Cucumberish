//
//  CCIFeaturesManager.h
//  CucumberishExample
//
//  Created by Ahmed Ali on 02/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CCIFeature;
@interface CCIFeaturesManager : NSObject

@property NSArray * features;


+ (instancetype)instance;


- (void)parseFeatureFiles:(NSArray *)featureFiles withTags:(NSArray *)tags;


- (void)setClass:(Class)klass forFeature:(CCIFeature *)feature;
- (CCIFeature *)getFeatureForClass:(Class)klass;
@end
