//
//  Cucumberish.h

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

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "CCIStepsManager.h"
#import "CCIBlockDefinitions.h"


/**
 Cucumberish is the main class you will need to parse your feature files and execute them.
 You should not create instances of this class directly, instead you need to use the instance method.
 
 @see +[Cucumberish instance]
*/
@interface Cucumberish : NSObject

/**
 As this being written, there is an issue with Xcode that causes the last scenario to disappear once it is done.
 If this causes an issue for your test report, change the value of this property to YES before calling beginExecution.
 
 @Note
 Thoguh the default value of this property is NO, it is highly recommended to set the value of this proeprty to YES.
 
 @Note
 This will cause Cucumberish to execute an additional scenario called cucumberishCleanupScenario which will immediately disappear instead of your real last scenario.
 Also this will increase the number of executed scenarios by 1. If you only have 6 scenarios, you will see 7 scenarios in the console message, and in your report navigator.
 
 */
@property (nonatomic) BOOL fixMissingLastScenario;

/**
 If you change this property value to YES, feature names and scenarios will appear in Xcode Test Navigator as is (allowing spaces and special characters).
 However, allowing pretty names might cause some issues with some tools like XCTool
 */
@property (nonatomic) BOOL prettyNamesAllowed;

/**
 If the name of folder that contains your test target files is different than the test target it self, then tell Cucumber the name of the folder through this property.
 This is important for proper error reporting.
 */
@property (nonatomic) NSString * testTargetFolderName;

/**
 Retuans a singleton instance of Cucumberish
 
 @return singleton instance of Cucumberish
 */
+ (instancetype)instance;

/**
 Parses any .feature file that is located inside the passed folder name and map it to a test case if the feature inside the file has one or more tags of the passed tags (if any) and it doesn't have a tag from the excluded tags parameter
 
 @param directory a path to your featuresDirectory relative to your test target main folder.
 @param bundle the bundle where the directory is located
 @param includeTags array of strings to filter which features that will be parsed to be executed, if nil then all feature files will be parsed.
 @param excludeTags array of string to filter which features should not be executed.
 
 @note The feature directory has to be a real physical folder. Also when adding this folder to your test target, and get the prompt on how you would like to add it from Xcode, choose "Create Folder Reference" and @b NOT to Create Groups.
 @note tags should not be prefixed with @@ symbole
 @note tags in includeTags parameter should not exist in the excludedTags parameter as it doesn't make any sense.
 @note the tags will be also on the scenario level. That's it, if the feature passes the tag check, then we will check each of its scenarios against the tags as well. But if a feature is excluded (because it has a tag from the excludedTags array), none of its scenarios will be executed.
 
  @return the singleton instance of Cucumberish so you can call beginExecution immediately if you want.
 */
- (Cucumberish *)parserFeaturesInDirectory:(NSString *)directory
                       fromBundle:(NSBundle *)bundle
                      includeTags:(NSArray<NSString *> *)includeTags
                      excludeTags:(NSArray<NSString *> *)excludeTags;

/**
 Parses any .feature file that is located inside the passed folder name and map it to a test case if the feature inside the file has one or more tags of the passed tags (if any) and it doesn't have a tag from the excluded tags parameter
 
 @param directory a path to your featuresDirectory relative to your test target main folder.
 @param includeTags array of strings to filter which features that will be parsed to be executed, if nil then all feature files will be parsed.
 @param excludeTags array of string to filter which features should not be executed.
 
 @note The feature directory has to be a real physical folder. Also when adding this folder to your test target, and get the prompt on how you would like to add it from Xcode, choose "Create Folder Reference" and @b NOT to Create Groups.
 @note If you followed the manual installation steps of Cucumberish, then make sure the features folder is the root folder of your project. Otherwise, it is better to use the parserFeaturesInDirectory:fromBundle:includeTags:excludeTags: method to specify the runtime bundle that will include the features folder.

 @note tags should not be prefixed with @@ symbole
 @note tags in includeTags parameter should not exist in the excludedTags parameter as it doesn't make any sense.
 @note the tags will be also on the scenario level. That's it, if the feature passes the tag check, then we will check each of its scenarios against the tags as well. But if a feature is excluded (because it has a tag from the excludedTags array), none of its scenarios will be executed.
 
 @return the singleton instance of Cucumberish so you can call beginExecution immediately if you want.
 */
- (Cucumberish *)parserFeaturesInDirectory:(NSString *)featuresDirectory
                               includeTags:(NSArray<NSString *> *)tags
                               excludeTags:(NSArray<NSString *> *)excludedTags;

/**
 Fire the execution of all the previously parsed features in an alphabetic ascending order.
 */
- (void)beginExecution;

/**
 Conventient method that calls parserFeaturesInDirectory:includeTags:excludeTags: followed by an immediate call to beginExecution
 
 */
+ (void)executeFeaturesInDirectory:(NSString *)featuresDirectory includeTags:(NSArray<NSString *> *)tags excludeTags:(NSArray<NSString *> *)excludedTags;

/**
 Conventient method that calls parserFeaturesInDirectory:fromBundle:includeTags:excludeTags: followed by an immediate call to beginExecution
 
 */
+ (void)executeFeaturesInDirectory:(NSString *)featuresDirectory fromBundle:(NSBundle *)bundle includeTags:(NSArray *)tags excludeTags:(NSArray *)excludedTags;

@end


