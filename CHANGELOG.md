#Change Log
### [v0.9.0](https://github.com/Ahmed-Ali/Cucumberish/releases/tag/v0.9.0)
   - Some code quality improvements. See PR #15
   - Added exclude by tag support. So now you can exclude features/scenarios by tag.
   - Tags are also checked on scenario level. If a feature passes the tag check (means it is not excluded), all of its scenarios will go through tag check as well.
   - Scenarios inherit tags from feature. So any tag for the feature will be also added automatically to its scenarios.
   - Small API update to give the tags parameter more meaningful name.
   - The jump in the version number is intentional as the project seems to be stable enough to reach version 1.0.   

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
