//
//  CCIFeaturesManager.h

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

#import <Foundation/Foundation.h>
@class CCIFeature;

/**
 CCIFeaturesManager is a singleton class and its main purpose is to parse feature files and map them to their associated Classes.
 This class is utilized by Cucumberish main class. Useually you do not need to deal with it manually.
 */
@interface CCIFeaturesManager : NSObject

/**
 After calling parseFeatureFiles:withTags: this array will contain all the parsed features.
 */
@property (nonatomic, readonly) NSArray<CCIFeature *> * features;

/**
 Returns the singleton class of CCIFeaturesManager
 */
+ (instancetype)instance;

/**
 Parses the feature files that matches one or more of the passed tags if any.
 
 @Note tags should not be prefixed with @@ symbole
 
 @param featureFiles array of NSURL that presents the feature file paths
 @param tags array of strings to filter which the features that will be parsed to be executed, if nil then all feature files will be parsed.
 */
- (void)parseFeatureFiles:(NSArray *)featureFiles withTags:(NSArray *)tags;

/**
 Associates the passed class with the passed feature instance for later usage.
 It is mainly used to eliminate the need create a class for a feature multiple times.
 @param class
 @param feature
 */
- (void)setClass:(Class)klass forFeature:(CCIFeature *)feature;

/**
 Returns the passed class that is associated with the passed feature.
 @param class
 */
- (CCIFeature *)getFeatureForClass:(Class)klass;
@end
