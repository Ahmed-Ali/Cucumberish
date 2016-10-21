//
//  CucumberishInitializer.swift
//  CucumberishExample
//
//  Created by Ahmed Ali on 23/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

import Foundation

class CucumberishInitializer: NSObject {
    class func CucumberishSwift()
    {
        var application : XCUIApplication!
        beforeStart { () -> Void in
            application = XCUIApplication()
            CCIStepDefinitions.setup(application);
        }
        Given("the app is running") { (args, userInfo) -> Void in
            application.launch()
        }
        
        And("all data cleared") { (args, userInfo) -> Void in
            let testCase = userInfo?[kXCTestCaseKey] as? XCTestCase
            SStep(testCase, "I tap the \"Clear All Data\" button")
        }

        let bundle = Bundle(for: CucumberishInitializer.self)
        Cucumberish.executeFeatures(inDirectory: "ExampleFeatures", from: bundle, includeTags: nil, excludeTags: nil)
        
    }
}

