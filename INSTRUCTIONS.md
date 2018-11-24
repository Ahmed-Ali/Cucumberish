## Install Instructions

These instructions were created from trial and error for the UITests Target

1. Create a new Xcode project
2. [x] Include UI Tests
3. In your Podfile include Cucumberish in your UITests Target
```
	use_frameworks!
	platform:ios, '11.0'

	target 'AppName' do
		use_frameworks!
	end

	target 'AppNameUITests' do
		inherit! :search_paths
		pod 'Cucumberish'
	end
```
4. Run `pod install`

5. In the navigation pane of your Xcode project: inside **AppNameUITests** folder create a new objc header file and rename it to: _AppName-Bridging-Header.h_ and add the following line in the meantime:
`#import <Cucumberish/Cucumberish.h>`

6. In the navigation pane of your Xcode project: inside **AppNameUITests** folder create a new objc implementation file and rename it to: _CucumberishTest.m_ and add the following contents:

```
#import "AppNameUITests-Swift.h"

void CucumberishInit(void);

__attribute__((constructor))
void CucumberishInit()
{
    [CucumberishInitializer CucumberishSwiftInit];
}
```

7. In the navigation pane of your Xcode project: add a new **__folder__** inside **AppNameUITests** folder and name it **Features**

Here you will create new empty files with the name of the feature follow by the `.feature` file extension as an example name it _Login.feature_

8. Add a new swift file inside the folder **AppNameUITests** and name it _CucumberishInitializer.swift_
9. Inside _CucumberishInitializer.swift_ add the following content:

```
import Foundation
import Cucumberish

@objc public class CucumberishInitializer: NSObject {
    @objc public class func CucumberishSwiftInit() {
        var application: XCUIApplication!

        beforeStart { () -> Void in
            application = XCUIApplication()
            LoginSteps().LoginStepsImplementation()
            SignUpSteps().SignUpStepsImplementation()
            CommonStepDefinitions().CommonStepDefinitionsImplementation()
        }

        let bundle = Bundle(for: CucumberishInitializer.self)

        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: nil)
    }
}
```

10. Create a new folder inside **AppNameUITests** directory and name it **StepDefinitions**
11. As an example create a new swift file a name it _LoginStep.swift_ , which is where the actually Gherkin language is match with Regex

```
import Foundation
import Cucumberish

class LoginSteps: LoginScreen {

    func LoginStepsImplementation() {
        Given("I'm a new user that is registering for the first time") { args, dataTable in
            // call your unit test implementations
			XCTAssertTrue(...)
        }

        When("the user submits the registration form with the following details") { args, dataTable in
            // call your unit test implementations
			XCTAssertTrue(...)
        }

        Then("the user is successfully registered") { args, dataTable in
            // call your unit test implementations
			XCTAssertTrue(...)
        }

```

12. Run your UITests [CMD + U] and you will see the XCTest classes being generate it in the process.
