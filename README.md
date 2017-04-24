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

# Install Manually
- [Install manually for Objective-C](https://github.com/Ahmed-Ali/Cucumberish/wiki/Install-manually-for-Objective-C) test targets
- [Install manually for Swift](https://github.com/Ahmed-Ali/Cucumberish/wiki/Install-manually-for-Swift) test targets

# Install with CocoaPods

Add the following to your Podfile

```Ruby
use_frameworks!
target 'YourAppTestTarget' do
  pod 'Cucumberish'
end
```
And follow the rest for the setup steps:
- [Setup Cucumberish with Cocoapods (Objective C)
](https://github.com/Ahmed-Ali/Cucumberish/wiki/Setup-Cucumberish-with-Cocoapods-(Objective-C))
- [Setup Cucumberish with Cocoapods (Swift)](https://github.com/Ahmed-Ali/Cucumberish/wiki/Setup-Cucumberish-with-Cocoapods-(Swift))

# Install with Carthage
- [Install with Carthage for Objective C](https://github.com/Ahmed-Ali/Cucumberish/wiki/Install-with-Carthage-for-Objective-C) test targets
- [Install with Carthage for Swift](https://github.com/Ahmed-Ali/Cucumberish/wiki/Install-with-Carthage-for-Swift) test targets

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
    
    Then(@"I will be more confident about the quality of the project and its releases", ^(NSArray<NSString *> *args, NSDictionary *userInfo) {
        NSLog(@"Implemented step for the sake of the example");
    });

```

And that's it! You have implemented your first feature scenario steps!
For more information about the steps, the blocks that are passed to it and the hooks, check the [CCIBlockDefinitions.h](https://github.com/Ahmed-Ali/Cucumberish/blob/master/Cucumberish/Core/CCIBlockDefinitions.h) file and [Cucumberish Wiki](https://github.com/Ahmed-Ali/Cucumberish/wiki).

# Examples
Beside all the information you can find on the [wiki](https://github.com/Ahmed-Ali/Cucumberish/wiki) and specifically the [Steps Definition](https://github.com/Ahmed-Ali/Cucumberish/wiki/Step-Definitions) page, seeing examples in action is the best way to demonstrate something. You can clone this repository and open the file `CucumberishLibraryTest/CucumberishLibrary.xcodeproj`.


In the `CucumberishLibrary` project there are five targets:

1. CucumberishLibrary target:
    - This is the main target that includes the Cucumberish library, we use it as our testable target to test it in the test targets.
    
2. CucumberishFeatureDefinition target:
    - This target is mainly a demonstration of different ways to define a step implemnetation and to get you familiar with most of Cucumberish APIs.
    - Most of the steps in this target uses bit complicated regular expressions strings, but you should not worry about that. As long as you know some of the basics of regular expressions, you should be fine. The [Steps Definition](https://github.com/Ahmed-Ali/Cucumberish/wiki/Step-Definitions) page can be of great help if you are not so familiar with regular expressions.

3. CucumberishTests Target:
    - In this target we use the Cucumberish library to test its own behaviour.
	

# Unit Tests
The CucumberishLibrary project, located in the CucumberLibraryTest folder, contains two targets, CucumberishTests and CucumberishFeatureDefinition, which are used to test Cucumberish itself.

            
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

# Known Issues
When executing individual scenario or feature from the test navigator, the rest of test cases will disappear. You will have to run all the tests by pressing CMD+U (or from the Tests button) in order for the test cases to appear again.
    
# Contributing
I am so glad that you are interested in contributing to Cucumberish.
When you have made some improvements or additions that you would like to see in the master repository, please [create a pull request](https://github.com/Ahmed-Ali/Cucumberish/pulls) and I will merge it as soon as possible.

# License
Cucumberish is available under the **MIT** license. See the [LICENSE](https://github.com/Ahmed-Ali/Cucumberish/blob/master/LICENSE) file for more information.
