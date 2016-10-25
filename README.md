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

# Installation (Manual)
You can install Cucumberish with the following steps in no more than few minutes.

1. Copy the contents of the Cucumberish folder into your test target folder and add it to your test target. When prompted check the "Copy items if needed" and chose "Create groups".
2. This step is super important for proper reporting. Go to your test target build settings, and add the following preprocessor macro:

    ```
    SRC_ROOT=@\"$(SRCROOT)\"
    ```
    
    
# Installation (with CocoaPods)

[CocoaPods](http://cocoapods.org) makes it super easy to install Cucumberish.

Add the following to your Podfile

```Ruby


target 'YourAppTestTarget' do
  pod 'Cucumberish'
end
```


# Post Installation Steps
Take deep breath and follow the following steps exactly to save as much as possible of your own time. And pay a lot of attention to the comments in the code.

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
                //Tell Cucumberish the name of your features folder, and which bundle contain this directory. And Cucumberish will handle the rest...
                //The ClassThatLocatedInTheRootTestTargetFolder could be any class that exist side by side with your Features folder.
                //So if ClassThatLocatedInTheRootTestTargetFolder exist in the directory YourProject/YourTestTarget
                //Then in our example your .feature files are expected to be in the directory YourProject/YourTestTarget/Features
                NSBundle * bundle = [NSBundle bundleForClass:[ClassThatLocatedInTheRootTestTargetFolder class]];
		
                [Cucumberish executeFeaturesInDirectory:@"Features" fromBundle:bundle includeTags:nil excludeTags:nil];
            }
            ```
        
    - ##### For Swift test targets:
        1. Replace the content of the default .swift test case file that was created for your test target with the following:
        
            ```Swift
            import Foundation
	    import Cucumberish //Applicable only if you use Cocoapods installation with use_frameworks!
            class CucumberishInitializer: NSObject {
                class func CucumberishSwiftInit()
                {
                    //Using XCUIApplication only available in XCUI test targets not the normal Unit test targets.
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
                        let testCase = userInfo?[kXCTestCaseKey] as? XCTestCase
                        SStep(testCase, "I tap the \"Clear All Data\" button")
                    }
                    //Tell Cucumberish the name of your features folder and let it execute them for you...
                    let bundle = Bundle(for: CucumberishInitializer.self)
                    Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: nil)
                }
            }
            ```
        
        2. Create a new Objective-C .m file
        
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
	  4. If you use Cocoapods installation with the use_frameworks! flag, then just use the following in your Swift files. Otherwise, skip this step and apply the following steps.
            
            ```Swift
	    
	    import Cucumberish
	    ```
	    *The following steps to create the bridge header is only needed if don't use Cocoapods installation or you use it without the use_frwameroks! flag*
	   5. Create a bridge file and name it (just an example) bridging-header.h and save it in the folder of that test target.
	   6. Open the target Build Settings and set the value of "Objective-C Bridging Header" to be
            
            ```
	   	${SRCROOT}/${TARGET_NAME}/bridging-header.h
	    ```
	    7. In the bridge header you just created, add the following import:
	   
            ```Objective-C
	   
            #import "Cucumberish.h" //or #import <Cucumberish/Cucumberish.h> if installed with Cocoapods
            ```
	    
4. Only in case the name of folder that contains your test target files is different than the test target name, set the value of the Cucumberish property testTargetFolderName to the correct folder name.

And that's it! You are ready to get started!

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
    
    
    # The grammar being used is completely defined by you and your team; it is up to you to find the best way to define your functionality.
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


In the `CucumberishExample` project there are five targets:

1. CucumberishExample target:
    - Is a very small app with a few screens and an easy to understand flow and implementation. It requires Xcode 8 to run. On the Storyboards most of the UI components have accessibility labels.
    - In case the test target that uses KIF failes to find the UI elements, you need to open the accessibility inspector from Xcode menu > Developer Tools
    
2. CucumberishExampleTests target:
    - This target uses [KIF](https://github.com/kif-framework/KIF) to interact with the UI in the steps implementation.
    - It's a very good idea to take a look at the file CucumberishExampleTests/Steps/CCIStepsUsingKIF.m for many examples of how to define your step implementations in many different ways. This target uses Objective-C.
    - While walking through the step imeplementations, see how this implementation is being used in the CucumberishExampleTests/ExampleFeatures .feature files.
    - Most of the steps in this target uses bit complicated regular expressions strings, but you should not worry about that. As long as you know some of the basics of regular expressions, you should be fine. The [Steps Definition](https://github.com/Ahmed-Ali/Cucumberish/wiki/Step-Definitions) page can be of great help if you are not so familiar with regular expressions.

3. CucumberishExampleUITests Target:
    - While I was not too impressed by Apple's UI automation API and its many limitions, I've nonetheless added an example target to complete the chain. It has a smaller set of step implementation examples, and is written in Swift.
Feel free to take these step implementations as a starting point and use them as much as you want; just remember to choose what fits best with your needs because you will build your own implementations in all cases.
	

4. CucumberishTest:
    - This target contains test cases for the behaviour of the Cucumberish framework itself. This is accomplished by comparing the order of feature, scenario and step execution and their associated classes and methods that are supposed to appear in the Xcode test navigator.
 
5. CucumberishFeatureDefinition
    - More test for the framework it self in Unit Test style rather than behaviour testing. 

# Unit Tests
The example project containt two targets, CucumberishTest and CucumberishFeatureDefinition, which are used to test Cucumberish itself.

            
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


    
# Contributing
I am so glad that you are interested in contributing to Cucumberish.
When you have made some improvements or additions that you would like to see in the master repository, please [create a pull request](https://github.com/Ahmed-Ali/Cucumberish/pulls) and I will merge it as soon as possible.

# License
Cucumberish is available under the **MIT** license. See the [LICENSE](https://github.com/Ahmed-Ali/Cucumberish/blob/master/LICENSE) file for more information.
