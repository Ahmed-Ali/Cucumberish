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
 If Cucumberish is installed with Carthage, set the value of this property to be SRC_ROOT which is the preprocessor macro you defined in your build settings
 */
@property (nonatomic, strong) NSString * testTargetSrcRoot;

/**
 Retuans a singleton instance of Cucumberish
 
 @return singleton instance of Cucumberish
 */
+ (instancetype)instance;

/**
 Parses all the .feature files so they can be executed once you call beginExecution
 
 @note The features directory has to be a real physical folder. Also when adding this folder to your test target, and get the prompt on how you would like to add it from Xcode, choose "Create Folder Reference" @b Instead @b of "Create Groups".

 @note When working with tags, the following should be considered:

    - The tags passed to includeTags or excludeTags should not be prefixed with @@ symbole
 
    - If a the same tag exist in both includeTags and excludeTags, the excludeTags overrides the includeTags; so any feature with that tag will not be executed.
 
    - When the includeTags has value (and not nil), Cucumberish will excute only the scenarios that has at least one of these tags and dosn't have any tags that that exist in the excludeTags parameter.
 
    - Since scenarios inherit the tags from its feature, if a feature has a tag that exist in the excludeTags parameter, then this feature will be ignored completely.
 
 
 @param directory the name of your features' folder that exists in your test target root folder.
 @param bundle the main bundle of your test target
 @param includeTags array of strings to filter which scenarios to be executed, if nil then all features will be considered to be executed if there they don't have any tag that exists in the array of the excludeTags.
 @param excludeTags array of strings to filter which features/scenarios should not be executed. This parameter have precedence over the includeTags parameter
 
 
 
  @return the singleton instance of Cucumberish so you can call beginExecution immediately if you want.
 */
- (Cucumberish *)parserFeaturesInDirectory:(NSString *)directory
                       fromBundle:(NSBundle *)bundle
                      includeTags:(NSArray<NSString *> *)includeTags
                      excludeTags:(NSArray<NSString *> *)excludeTags;





/**
 Fires the execution of all the previously parsed features in an alphabetic ascending order.
 */
- (void)beginExecution;



/**
 Conventient method that calls parserFeaturesInDirectory:fromBundle:includeTags:excludeTags: followed by an immediate call to beginExecution
 
 */
+ (void)executeFeaturesInDirectory:(NSString *)featuresDirectory fromBundle:(NSBundle *)bundle includeTags:(NSArray *)tags excludeTags:(NSArray *)excludedTags;


#pragma mark - deprecated methods
/**
 Conventient method that calls parserFeaturesInDirectory:includeTags:excludeTags: followed by an immediate call to beginExecution
 
 */
+ (void)executeFeaturesInDirectory:(NSString *)featuresDirectory includeTags:(NSArray<NSString *> *)tags excludeTags:(NSArray<NSString *> *)excludedTags DEPRECATED_MSG_ATTRIBUTE("This method is deprecated because it can cause issues if you installed Cucumberish using Cocoapods. Instead use the method executeFeaturesInDirectory:fromBundle:includeTags:(NSArray *)tags excludeTags:");




- (Cucumberish *)parserFeaturesInDirectory:(NSString *)directory
                               includeTags:(NSArray<NSString *> *)tags
                               excludeTags:(NSArray<NSString *> *)excludedTags DEPRECATED_MSG_ATTRIBUTE("This method is deprecated because it can cause issues if you installed Cucumberish using Cocoapods. Instead use the method parserFeaturesInDirectory:fromBundle:includeTags:excludeTags:");

@end


