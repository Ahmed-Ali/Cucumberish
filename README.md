# Cucumberish
Cucumberish is test automation framework for Behaviour Driven Development.
It is inspired by the amazing way of writing automated test cases introduced originally by Cucumber using Gherkin language.

**If you are not sure whether Cucumberish is for you or not checkout the [FAQ](#faq) section**
# Features

* Full integration with Xcode Test Navigator.
* Can be used with continues integration servers, or cloud services; just like XC unit tests!
* When any test fail, Xcode Test Navigator will point to your .feature file on the line that failed.
* Your test reports will appear in your Reports Navigator just like any XC unit tests.
* No Ruby, "command line-only", or any other non-ios related languages or chaotic dependency chain needed to install or use Cucumberish at all!
* Few minutes installation!
* Step implementations are done directly in Objective-C or Swift! Which means you can breakpoint and debug your steps implementations easily.
* Can be used with Unit Test as well as UI Test targets!

##### Here is a quick animated GIF that shows you how it ends up in action

![Cucumberish In Action](https://cloud.githubusercontent.com/assets/5157350/12704873/cf0a6dfe-c864-11e5-8a3b-8a3682d8e880.gif)

# Installation
You can install Cucumberish manually, in no more than few minutes, or using cocoapods.
If you will use Cucumberish with UI Test target, you should use the manual installation; for some reasons cocoapods fails to copy the required resources with UI Test targets.

### Manual
1. Copy the content of Cucumberish folder into your test target folder and add it to your test target as a reference not a folder.
2. This step is super important for proper reporting. Go to your test target build settings, and add the following preprocess macro:

    ```
    SRC_ROOT=$(SRCROOT)
    ```

3. And that's it for including Cucumberish in your project!


### CocoaPods
1. Add Cucumberish to your Podfile for your test target and run pod install.

   ```Ruby
	target 'MyTestTarget' do
  		pod 'Cucumberish', '~> 0.0.6'
	end

    ```
    
### Post installation steps:
1. Go to your test target folder and create a subfolder. Let's call it **Features**.
2. Add this folder to your test target in Xcode as a Folder, **not** a group! This is a very important step.
![Features Folder as Folder not a Group](https://cloud.githubusercontent.com/assets/5157350/12533357/f7a94448-c22d-11e5-904a-1c353a76d604.png)
3. Inside this folder, you will create the .feature files which will contain your test's features and scenarios.
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
                //Tell Cucumberish the name of your features folder and let it execute them for you...
                [[[Cucumberish instance] parserFeaturesInDirectory:@"Features" featureTags:nil] beginExecution];
            }
            ```
        
    - ##### For Swift test targets:
        1. Replace the content of the default .swift test case file that was created with your test target by the following:
        
            ```Swift
            import Foundation
            class CucumberishInitializer: NSObject {
                class func CucumberishSwiftInit()
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
                    //Tell Cucumberish the name of your features folder and let it execute them for you...
                    Cucumberish.executeFeaturesInDirectory("ExampleFeatures", featureTags: nil)
                }
            }
            ```
        
        2. Create a new Objective-C .m in the test target, when you do this Xcode will prompt you about creating a bridge file, confirm the creation of this file.
        3. In the .m file you just add replace whatever content it has with the following:
            
            ```Objective-C
            //Replace CucumberishExampleUITests with the name of your swift test target
            #import "CucumberishExampleUITests-Swift.h"
            __attribute__((constructor))
            void CucumberishInit()
            {
                [CucumberishInitializer CucumberishSwiftInit];
            }
            ```

        4. In the bridge header file that Xcode created for you in the first step above, add the following import
            ```Objective-C
            #import "Cucumberish.h"
            ```
    
# Getting started
Now you have Cucumberish in place and you followed all the installation and post-installation instructions; it is time to write a very sample feature and scenario with few steps.
Since the exact step implementations will be very different thing between one project and the other, we will not dig deep into it; we will just see the approach on how to get there. I will assume your test target is an Objective-C one for the sake of demonstration; but the same prenciples can be applied on Swift targets.

Start by creating a new file in your features folder, we will call it example.feature.

_Note:_ You can have only one feature per file, but as many scenarios as you want.

Open this file to edit in Xcode (or any text editor you prefer) and write the followin as your very first feature:
```Gherkin
Feature: Example
# This is a free text description as an inline documentation for your features, you can omit it if you want.
# However, it is very adviseble to well describe your features.
As someone who plans to automate the iOS project test cases, I will use Cucumberish.

# First scenario is the scenario name, which will also appear in a proper format in Xcode test navigator
Scenario: First scenario

    # This is the first step in the scenario
    # Also noteworthy; a "Given" step, should be treated as the step that defines the app state before going into the rest of the scenario
    # Or consider it as a precondition for the scenario;
    # For example to post a comment, the user most be logged in, then you should say something similar to "Given the user is logged in" as your Given step.
    Given I have a very cool app
    
    
    # The grammar being used, is completely defined by you and your QA team; it is up to you to find the best way to define your functionality.
    # Only keep in mind that every step must start with "Given", "When", "Then", "And", and "But".
    When I automate it with "Cucumberish"
    Then I will be more confident about the quality of the project and its releases
```

Now you have one cool feature in place, it is time to implement its steps. You only need to care about the steps, not the feature or the scenario it self. So your step implementations are done out of any context.

In the body of the CucumberishInit C function and before calling -[Cucumberish beginExecution] method, add the following:

``` Objective-C
    Given(@"I have a very cool app", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        //Now it is expected that you will do whatever necessary to make sure "I have a very cool app" condition is satisfied :)
        NSLog(@"\"Given I have a very cool app\" step is implemented");
    });
    
    // The step implementation matching text can be any valid regular expression text
    // Your regex capturing groups will be added to the args array in the same order they have been captured by your regex string
    When(@"^I automate it with \"(.*)\"$", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        NSLog(@"I am gonna automate my test cases with \"%@\"", args[0]);
    });
    
    Then(@"Then I will be more confident about the quality of the project and its releases", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        NSLog(@"Implemented step for the sake of the example");
    });

```

And that's it! You have implemented your first feature scenario steps!
For more information about the steps, the blocks that are passed to it, and the hooks; check the [CCIBlockDefinitions.h](https://github.com/Ahmed-Ali/Cucumberish/blob/master/Cucumberish/Core/CCIBlockDefinitions.h) file and [Cucumberish Wiki](https://github.com/Ahmed-Ali/Cucumberish/wiki).

# Examples
Beside all the information you can find in the [wiki](https://github.com/Ahmed-Ali/Cucumberish/wiki) and specifically the [Steps Definition](https://github.com/Ahmed-Ali/Cucumberish/wiki/Step-Definitions) page. Seeing examples in action is the best way to demonstrate something. You can clone this repository and open the file CucumberishExample/CucumberishExample.xcworkspace

*Note:* This workspace is the default workspace you get when you use Cocoapods.

In the CucumberishExampe project there are three targets:

1. Example app target:
    - It is very small app with few screens and easy to understand flow and imeplementation; in the storyboards most of its UI components has accessibility label. You can find the accessibility labels from storyboard directly or in the simulator using the accessibility inspector.
    
2. Unit test target:
    - This target uses [KIF](https://github.com/kif-framework/KIF) to interact with the UI in the steps implementation.
    - It is a very good idea to take a look at the file CucumberishExampleTests/Steps/CCIStepsUsingKIF.m to see many examples for how to define your step implementations in many different ways. This target uses Objective-C
    - While walking through the step imeplementations, see how this implementation is being used in the CucumberishExampleTests/ExampleFeatures .feature files.

3. UI Test Target:
    - While I was not impressed enough by Apple UI automation API and its so much limitions, I decided to add the example target to complete the chain. It has smaller set of step implementation examples, and written in Swift.
Feel free to take this step implementations as a starting point and use them as much as you want; just remember to choose what fits best with your needs because you will build your own implementations in all cases.
	- **Note:** When running this test target, make sure to disable the simulator auto correction feature; otherwise the XCUI tends to use the auto correction which results in unintended values being written in the text fields.

3. CucumberishTest:
    - This target contians test cases that tests the behaviour of the Cucumberish framework itself. This is accomplished by comparing the order of feature, scenario and step execution and their associated classes and methods that supposed to appear in Xcode Test Navigation
    

# Unit Tests
Cucumberish has a behavioural test cases that can be executed through the CucumberishTest scheme. To execute these test,  select the scheme and press CMD+U

            
# Troubleshooting
#### My test case scenario failed because the step is not implemented, but I am sure I implemented it, now what?
This can happen if your step definition text can not be matched against the step written in the feature file.
It can happen because of a mistake in your regex string, or maybe an additional unwated space has been added to either the definision of the step or the step it self.
A good place to put a breakpoint and see what is going on is in Cucumberish/Core/Managers/CCIStepsManagers.m in the method findDefinitionForStep:amongDefinitions:

#### My test case failed, but when I click on the failed case in Xcode test navigator it does not open the file where the failure occured.
So far this happens for two reasons:

    
1. If there is a a runtime crash in your code. E. g. when you try to access the fifth element of an array that has only four elements.
So it is believed to be meaningless to point to one of your feature files in such case. However, you still need to find out the issue; you can put an exception breakpoint or open the Report navigator in Xcode, click on the first Test item at the top of your reports. Inside this report the failed case will be expandable and will show you all the available information.
   
2. If you missed one of the first two steps of the [Manual installation](#manual-installation), in case you installed Cucumberish manually, or you missed the second step in the [Post installation steps](#post-installation-steps).

3. If you believe you have a different case, please report it as an issue.



# FAQ
1. How does Cucumberish work in brief?
	- It is very simple. You describe your features in .feature files, and define set of scenarios for each feature and each scenario has a set of steps. Then Cucumberish will create an XC test suite for each feature and an XCTestCase for each scenario. And will map the steps to your code. So it ends up with human-readable features and still implemented in a way we, as developers, prefer.
2. I want to use Swift in my test target, is it possible?
	- Yes, please checkout the UI test target in the example application. It is completely Swift! 
	
3. I prefer to use Apple UI test framework for long term support, is it still possible to do this with Cucumberish?
	- YES! You can combine Cucumberish with your prefered frameworks and tools! This also means Cucumberish is not limited to UI.

4. I still can't understand if it is what I am looking for? in that case you have some options
	- You can read the [wiki](https://github.com/Ahmed-Ali/Cucumberish/wiki), it is short and to the point.
	- You can read a bit about the original [Cucumber](https://cucumber.io) to get an idea how it has started and what it is all about
	- Finally you can always open an issue if you have a specific issue, or post your questions on StackOverFlow (and ping me), and I will be happy to help out.

# Continuous Integration

A continuous integration (CI) process is highly recommended and is extremely useful in ensuring that your application stays functional. The easiest way to do this will be either using Bots, or Jenkins or another tool that uses xcodebuild. For tools using xcodebuild, review the manpage for instructions on using test destinations.

# Aknowladgement
- Cucumberish made a good use of [Gherkin3](https://github.com/cucumber/gherkin) in order to parse .feature files. Without its Objective-C implementation, I would have implemented it from scratch. Gherkin3 saved me a lot of time.
- In the example app we used [KIF](https://github.com/kif-framework/KIF) as a good example of how you can implement steps that has to do with user interface. The guys behind this framework has done really amazing job!

    
# Contributing
I am so glad that you are interested in contributing to Cucumberish.
When you have made some improvement or addition that you would like to see in the master repository, please [creat a pull request](https://github.com/Ahmed-Ali/Cucumberish/pulls) and I will merge it as soon as possible.

# License
Cucumberish is available under **MIT** license. See the [LICENSE](https://github.com/Ahmed-Ali/Cucumberish/blob/master/LICENSE) file for more information.
