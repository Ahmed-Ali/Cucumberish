# Cucumberish
Cucumberish is a native Objective-C framework for Behaviour Driven Development inspired by the amazing way of writing automated test cases introduced originally by Cucumber.
For those who do not know what it means: Simply this framework will help developers and non-developers to write test cases in plain English and in a very organized manner.
# Features

* Full integration with Xcode Test Navigator.
* Can be used with continues integration servers, or cloud services; just like XC unit tests!
* When any test fail, Xcode Test Navigator will point to your .feature file on the line that failed.
* Your test reports will appear in your Reports Navigator just like any XC unit tests.
* No Ruby, "command line-only", or any other non-ios related languages or dependencies needed to install or use Cucumberish at all!
* Few minutes installation!
* Step implementations are done directly in Objective-C or Swift! Which means you can breakpoint and debug your steps implementations easily.
* Can be used with Unit Test as well as UI Test targets!

# Installation
You can install Cucumberish manually, in no more than few minutes (or maybe five if you have a really slow internet connection), or using cocoapods.
If you will use Cucumberish with UI Test target, you should use the manual installation; for some reasons cocoapods fails to copy the required resources with UI Test targets.

### Manual Installation
1. Copy the content of Cucumberish folder into your project and add it to your test target.
2. This step is super important for proper reporting. Go to your test target build settings, and the following preprocess macro:

    ```
    SRC_ROOT=$(SRCROOT)
    ```

3. And that's it for including Cucumberish in your project!


### Cocoapods Installation
1. Add Cucumberish pod to your podfile to be added to your test target and run pod install.

    ```
    target 'YourTestTargetName' do
        pod 'Cucumberish'
    end
    ```
### Post installation steps:
1. Go to your test target folder and create a subfolder. Let's call it **Features**.
2. Add this folder to your test target in Xcode as a Folder, **not** a group! This is a very important step.
![Features Folder as Folder not a Group](https://cloud.githubusercontent.com/assets/5157350/12533357/f7a94448-c22d-11e5-904a-1c353a76d604.png)
3. Inside this folder, you will create the .feature files which will contain your test features/scenarios.
    - ##### For Objective-C test targets:
        - When you create a test target, Xcode creates a test case file for you. Open this file and replace its content with the following:
        
            ```Objective-C
            #import "Cucumberish.h"
            //#import <Cucumberish/Cucumberish.h> if installed using cocoapods
            __attribute__((constructor))
            void CucumberishInit()
            {
                //Define your step implememntations (the example project contains set of basic implementations using KIF)
                Given(@"it is home screen", ^void(NSArray *args, id userInfo) {
                    //Step implementation code goes here
                });
                And(@"all data cleared", ^void(NSArray *args, id userInfo) {
                    //Step implementation code goes here
                });
                //Optional step, see the comment on this property for more information
                [Cucumberish instance].fixMissingLastScenario = YES;
                //Tell Cucumber the name of your features folder and let it execute them for you...
                [[[Cucumberish instance] parserFeaturesInDirectory:@"Features" featureTags:nil] beginExecution];
            }
            ```
        
    - ##### For Swift test targets:
        1. Create and add an Objective-C .m file to your test target, when you do this Xcode will prompt you about creating a bridge file, confirm the creation of this file.
        2. In the .m file you just add replace whatever content it has with the following:
            
            ```Objective-C
            //Replace CucumberishExampleUITests with the name of your swift test target
            #import "CucumberishExampleUITests-Swift.h"
            __attribute__((constructor))
            void CucumberishInit()
            {
                [CucumberishInitializer CucumberishSwiftInit];
            }
            ```

        3. In the bridge header file that Xcode created for you in the first step above, add the following import
            ```Objective-C
            #import "Cucumberish.h"
            ```
        4. Last but not least, replace the content of the default .swift test case file that created with your test target with the following:
        
            ```Swift
            import Foundation
            class CucumberishInitializer: NSObject {
                class func CucumberishSwift()
                {
                    var application : XCUIApplication!
                    //A closure that will be executed just before executing any of your features
                    beforeStart { () -> Void in
                        application = XCUIApplication()
                    }
                    //A Given step definition
                    Given("the app is running") { (args, userInfo) -> Void in
                        application.launch()
                    }
                    //Another step definition
                    And("all data cleared") { (args, userInfo) -> Void in
                        //Assume you defined an "I tap on \"(.*)\" button" step previousely, you can call it from your code as well.
                        SStep("I tap the \"Clear All Data\" button")
                    }
                    //Tell Cucumber the name of your features folder and let it execute them for you...
                    Cucumberish.executeFeaturesInDirectory("ExampleFeatures", featureTags: nil)
                }
            }
            ```
            
            
# To Be Continued
