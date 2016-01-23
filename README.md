# Cucumberish
Cucumberish is a native Objective-C framework for Behaviour Driven Development inspired by the amazing way of writing automated test cases introduced originally by Cucumber.
For those who do not know what it means: Simply this framework will help developers and non-developers to write test cases in plain English and in a very organized manner.
# Features
* Full integration with Xcode Test Navigator.
* When any test case fail, Xcode Test Navigator will point to your .feature file on the line that failed.
* Your test reports will appear in your Reports Navigator just like any XC unit tests.
* No Ruby, "command line-only", or any other non-ios related languages or dependencies needed to install or to use Cucumberish.
* Few minutes installation!
* Step implementations are done directly in Objective-C or Swift!
* Can be used with Unit Test as well as UI Test targets!

# Installation
You can install Cucumberish manually, in no more than two minutes (or maybe five if you have a really slow internet connection), or using cocoapods.
If you will use Cucumberish with UI Test target, you should use the manual installation; for somereason cocoapods fails to copy the required resources with UI Test targets.

### Manual Installation
1. Copy the content of Cucumberish folder into your project and add it to your test target.
2. This step is super important for proper reporting. Go to your test target build settings, and the following preprocess macro:
    ```
    SRC_ROOT=$(SRCROOT)
3. And that's it for including Cucumberish in your project! You can move on directly to the getting started part.

### Cocoapods Installation
1. Add Cucumberish pod to your podfile to be added to your test target and run pod install.
    ```
    target 'YourTestTargetName' do
        pod 'Cucumberish'
    end

#To Be Continued ...
