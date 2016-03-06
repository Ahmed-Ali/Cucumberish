# Cucumberish
Cucumberish is a test automation framework for Behaviour Driven Development (BDD).
It is inspired by the amazing way of writing automated test cases introduced originally in Cucumber using the Gherkin language.

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

##### Here is a quick animated GIF showing Cucumberish in action: 

![Cucumberish In Action](https://cloud.githubusercontent.com/assets/5157350/12704873/cf0a6dfe-c864-11e5-8a3b-8a3682d8e880.gif)

# Installation
You can install Cucumberish manually, in no more than few minutes, or using CocoaPods.
If you're using Cucumberish with a UI Test target, you should use the manual installation; for some reason CocoaPods fails to copy the required resources for UI Test targets.
### CocoaPods
1. Add Cucumberish to your Podfile for your test target and run `pod install`.

```Ruby
target 'MyTestTarget', :exclusive => true do
  pod 'Cucumberish', '~> 0.0.7', :configurations => ['Debug']
end
```

### Manual
1. Copy the contents of the Cucumberish folder into your test target folder and add it to your test target as a reference, not a folder.
2. This step is super important for proper reporting. Go to your test target build settings, and add the following preprocessor macro:

    ```
    SRC_ROOT=$(SRCROOT)
    ```

And that's it for including Cucumberish in your project!



    
### Post installation steps:
1. Go to your test target folder and create a subfolder. Let's call it **Features**.
2. Add this folder to your test target in Xcode as a Folder, **not** a group! This is a very important step.
![Features Folder as Folder not a Group](https://cloud.githubusercontent.com/assets/5157350/12533357/f7a94448-c22d-11e5-904a-1c353a76d604.png)
3. Inside this folder, you will create the .feature files which will contain your test's features and scenarios.
    - ##### For Objective-C test targets:
        - When you create a test target, Xcode creates a test case file for you. Open this file and replace its content with the following:
        
            ```Objective-C
            #import "Cucumberish.h"
            //#import <Cucumberish/Cucumberish.h> if installed using CocoaPods
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
        1. Replace the content of the default .swift test case file that was created for your test target with the following:
        
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
        
        2. Create a new Objective-C .m in the test target, when you do this Xcode will prompt you about creating a bridge file: confirm the creation of this file.
        3. Replace the contents of this file with the following:
            
            ```Objective-C
            //Replace CucumberishExampleUITests with the name of your swift test target
            #import "CucumberishExampleUITests-Swift.h"
            __attribute__((constructor))
            void CucumberishInit()
            {
                [CucumberishInitializer CucumberishSwiftInit];
            }
            ```

        4. In the bridge header file that Xcode created for you in the first step above, add the following import:
            ```Objective-C
            #import "Cucumberish.h"
            ```
4. Only in case the name of folder that contains your test target files is different than the test target name, set the value of the Cucumberish property testTargetFolderName to the correct folder name.

# Getting started
Now you have Cucumberish in place and you followed all the installation and post-installation instructions; it is time to write your first simple feature and scenario in just a few more steps!
Since the exact step implementations will differ between one project and another, we will not dig to deeply into it; we will just outline the general approach on how to get there. I will assume your test target is an Objective-C one for the sake of demonstration; but the same principles can be applied on Swift targets.

Start by creating a new file in your features folder; we will call it `example.feature`.

_Note:_ You can have only one feature per file, but as many scenarios as you want.

Open this file to edit in Xcode (or any text editor you prefer) and write the following for your very first feature:
```Gherkin
Feature: Example
# This is a free text description as an inline documentation for your features, you can omit it if you want.
# However, it is advisable to describe your features well.
As someone who plans to automate the iOS project test cases, I will use Cucumberish.

# First scenario is the scenario name, which will also appear in a proper format in Xcode test navigator
Scenario: First scenario

    # This is the first step in the scenario
    # Also noteworthy; a "Given" step should be treated as the step that defines the app state before going into the rest of the scenario
    # Or consider it as a precondition for the scenario;
    # For example if the user must be logged in to post a comment, then you should say something like "Given the user is logged in" as your Given step.
    Given I have a very cool app
    
    
    # The grammar being used is completely defined by you and your QA team; it is up to you to find the best way to define your functionality.
    # Only keep in mind that every step must start with "Given", "When", "Then", "And", or "But".
    When I automate it with "Cucumberish"
    Then I will be more confident about the quality of the project and its releases
```

Now you have one cool feature in place, it is time to implement its steps. You only need to care about the steps, not the feature or the scenario itself. So your step implementations are done without context.

In the body of the CucumberishInit C function and before calling the `-[Cucumberish beginExecution]` method, add the following:

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
For more information about the steps, the blocks that are passed to it and the hooks, check the [CCIBlockDefinitions.h](https://github.com/Ahmed-Ali/Cucumberish/blob/master/Cucumberish/Core/CCIBlockDefinitions.h) file and [Cucumberish Wiki](https://github.com/Ahmed-Ali/Cucumberish/wiki).

# Examples
Beside all the information you can find on the [wiki](https://github.com/Ahmed-Ali/Cucumberish/wiki) and specifically the [Steps Definition](https://github.com/Ahmed-Ali/Cucumberish/wiki/Step-Definitions) page, seeing examples in action is the best way to demonstrate something. You can clone this repository and open the file `CucumberishExample/CucumberishExample.xcworkspace`.

*Note:* This workspace is the default workspace you get when you use CocoaPods.

In the `CucumberishExample` project there are three targets:

1. Example app target:
    - It's a very small app with a few screens and an easy to understand flow and implementation. On the Storyboards most of the UI components have accessibility labels. You can view the accessibility labels inside the Storyboard directly or in the iOS Simulator using the Accessibility Inspector (click the Home button, open Settings and go to General > Accessibility).
    
2. Unit test target:
    - This target uses [KIF](https://github.com/kif-framework/KIF) to interact with the UI in the steps implementation.
    - It's a very good idea to take a look at the file CucumberishExampleTests/Steps/CCIStepsUsingKIF.m for many examples of how to define your step implementations in many different ways. This target uses Objective-C.
    - While walking through the step imeplementations, see how this implementation is being used in the CucumberishExampleTests/ExampleFeatures .feature files.

3. UI Test Target:
    - While I was not too impressed by Apple's UI automation API and its many limitions, I've nonetheless added an example target to complete the chain. It has a smaller set of step implementation examples, and is written in Swift.
Feel free to take these step implementations as a starting point and use them as much as you want; just remember to choose what fits best with your needs because you will build your own implementations in all cases.
	- **Note:** When running this test target, make sure to disable the Simulator auto-correction feature; otherwise the XCUI tends to use the auto-correction which results in unintended values being written in the text fields.

3. CucumberishTest:
    - This target contains test cases for the behaviour of the Cucumberish framework itself. This is accomplished by comparing the order of feature, scenario and step execution and their associated classes and methods that are supposed to appear in the Xcode test navigator.
    

# Unit Tests
Cucumberish has behavioural test cases that can be executed through the CucumberishTest scheme. To execute these tests select the scheme and press ⌘+U.

            
# Troubleshooting
#### My test case scenario failed because the step is not implemented, but I am sure I implemented it — now what?
This can happen if your step definition text can not be matched against the step written in the feature file.
It can happen because of a mistake in your regex string, or maybe an additional unwated space has been added to either the definition of the step or the step itself.
A good place to put a breakpoint and see what is going on is in `Cucumberish/Core/Managers/CCIStepsManagers.m` in the method `findDefinitionForStep:amongDefinitions`:

#### My test case failed, but when I click on the failed case in the Xcode test navigator it does not open the file where the failure occured.
This is known to happen for two reasons:
    
1. If there is a a runtime crash in your code, for example when you try to access the fifth element of an array that has only four elements.
It is believed to be meaningless to point to one of your feature files in such a case. However, you still need to find the issue; you can put an exception breakpoint or open the Report navigator in Xcode and click on the first Test item at the top of your reports. Inside this report the failed case will be expandable and will show you all the available information.
   
2. If you missed one of the first two steps of the [Manual installation](#manual-installation), in case you installed Cucumberish manually, or you missed the second step in the [Post installation steps](#post-installation-steps).

If you believe you've identified another type of failure, please report it as an issue.

# FAQ
1. How does Cucumberish work in brief?
	- It is very simple. You describe your features in `.feature` files and define a set of scenarios for each feature where each scenario has a set of steps. Then Cucumberish will create an XC test suite for each feature and an XCTestCase for each scenario, and will map the steps to your code. So it ends up with human-readable features and still implemented in a way we, as developers, prefer.
2. I want to use Swift in my test target, is it possible?
	- Yes, please checkout the UI test target in the example application. It is completely Swift! 
	
3. I prefer to use Apple UI test framework for long-term support, is it still possible to do this with Cucumberish?
	- YES! You can combine Cucumberish with your prefered frameworks and tools! This also means Cucumberish is not limited to UI.

4. I still don't know if Cucumberish is right for me. Is it? You have some options:
	- You can read the [wiki](https://github.com/Ahmed-Ali/Cucumberish/wiki), it is short and to the point.
	- You can read a bit about the original [Cucumber](https://cucumber.io) to get an idea how it has started and what it is all about
	- Finally you can always open an issue if you have a specific issue, or post your questions on StackOverflow (and ping me), and I will be happy to help out.

# Continuous Integration

A continuous integration (CI) process is highly recommended and is extremely useful in ensuring that your application stays functional. The easiest way to do this will be either using Bots, or Jenkins or another tool that uses xcodebuild. For tools using xcodebuild, review the manpage for instructions on using test destinations.

# Acknowledgements
- Cucumberish makes good use of [Gherkin3](https://github.com/cucumber/gherkin) in order to parse .feature files. Without its Objective-C implementation, I would have had to implement it from scratch. Gherkin3 saved me a lot of time!
- In the example app we used [KIF](https://github.com/kif-framework/KIF) as a good example of how you can implement steps related to the user interface. The guys behind this framework have done a really amazing job!

# To do (Wish to have)
The following is a list of cool complimentary (free and open source) tools we would like to be able to deliver as soon as possible (as separate projects)
- An Xcode plugin that can:
	1. Warn you about unimplemented steps and suggest definition regex.
	2. Jump from step to it's implementation
	3. Auto complete your steps in .feature files
	4. Format and highlight your .feature files

- An Xcode template for test target so you can get started in no time.
    
# Contributing
I am so glad that you are interested in contributing to Cucumberish.
When you have made some improvements or additions that you would like to see in the master repository, please [create a pull request](https://github.com/Ahmed-Ali/Cucumberish/pulls) and I will merge it as soon as possible.

# License
Cucumberish is available under the **MIT** license. See the [LICENSE](https://github.com/Ahmed-Ali/Cucumberish/blob/master/LICENSE) file for more information.
