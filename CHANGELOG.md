#Change Log

### [v1.1.0](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v1.1.0)

   - Added the ability report failures in BeforeStart hocks. See PR #38. Thanks to @brentleyjones
   - Replaced the CucumberishExample project with the library project, which simplifies the demonstration of the framework. See PR #39 . Thanks to @sidekickr
   - Cucumberish now can output the execution result formatted like the its Ruby version. See PR #39 . Thanks to @sidekickr.

### [v1.0.6](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v1.0.6)

   - Added the ability to execute individual test cases from the test navigator.
   - Improved the tags handling to work on the scenario level instead of the feature level only. See issue #31 
   - The CucumberishExample scheme was ignored by mistake, but has been re-added.


### [v1.0.5](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v1.0.5)

   - Added support to Carthage.
   - Moved the installation instructions to the repo's Wiki for the sake of simplicity.

### [v1.0.4](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v1.0.4)

   - Merged PR #26 to fix an issue with regex matching
   - Resolved all the warnings currently exist Cucumberish
	
### [v1.0.3](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v1.0.3)

   - Minor update to fix issue with Cocoapods installation that causes Cucumberish to be unable to report errors on .feature files
   - Updated the README.md for more clear instructions when use Cocoapods installation with use_frameworks! flag.

### [v1.0.2](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v1.0.2)

   - Many documentation updates to simplify the API
   - Updated the example projects and the code snippets in the readme file to reflect the latest changes
   - Validated the Cocoapods installation and its fixed some related issues.
   - Merged PR #23 to fix an issue with Regular expression matching

### [v1.0.1](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v1.0.1)

   - Merged PR #22 to fix a bug with the afterAll block execution.
   - Minor update to the Cucumberish unit test

### [v1.0.0](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v1.0.0)
Given the fact that we have faced only minor issues for a while and the current implementation seems stable and reach enough,  we are happy to release version 1.0 of Cucumberish. Happy testing :)

   - Now in each step implementation you will be able to receive an instance of the currently being executed XCTestCase class.
   - Scenario outlines now supports the usage of variables in its example. See PR #20 for more information. Credits for this change reserved for @sidekickr.
   - Swift examples has been upgraded to Swift 3 and Xcode 8.
   - Some minor issues fixed and improvements.

### [v0.0.7.1](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.0.7.1)
   - Fixed minor bug that causes issue when the test target folder path contain spaces. See PR #14
      
### [v0.0.7](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.0.7)
   - Included the latest update for Gherkin 4.
   - Fixed some minor bugs related to the execution of Background scenarios.
   - Fixed some minor bugs related to setting up the SRC_ROOT micro (please review the installation steps one more time if you are upgrading from older version).


### [v0.0.6](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.0.6)
   - Refactored and documented most of CCI model classes
   - Added test case to validate the .feature parsed content (known as Pickles in Cucumber)
    
### [v0.0.5.1](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.0.5.1)
   - Pretty test case names is now turned off by default to avoid execution issue with xctool
   
### [v0.0.5](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.0.5)
   - Added test cases to test Cucumberish framework behaviour
   
### [v0.0.4.1](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.0.4.1)
   - Contains no code changes, only configuration changes related to cocoapods   

### [v0.0.4](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.0.4)
   - Updated the Feature names and Scenario names to appear as is in Xcode Test Navigator instead of camel case.

### [v0.0.3](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.0.3)
   - Minor fix for loading Gherking language resource with cocoapods
   
### [v0.0.2](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.0.2)
   - Minor changes in podspec file and the example project scheme

### [v0.0.1](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.0.1) 
   - The very first initial release of Cucumberish
