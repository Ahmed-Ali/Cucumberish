//
//  CCIStepDefinitions.swift
//  CucumberishExample
//
//  Created by Ahmed Ali on 23/01/16.
//  Copyright © 2016 Ahmed Ali. All rights reserved.
//

import XCTest

class CCIStepDefinitions: NSObject {
    fileprivate var application : XCUIApplication!
    
    fileprivate func elementByLabel(_ label : String, type: String) -> XCUIElement
    {
        var elementQurey : XCUIElementQuery!
        switch(type){
        case "button":
            elementQurey = application.buttons
        case "label":
            elementQurey = application.staticTexts
        case "tab":
            elementQurey = application.tabs
        case "field", "text field":
            elementQurey = application.textFields
        case "textView", "text view":
            elementQurey = application.textViews
        case "view":
            elementQurey = application.otherElements
        default: elementQurey = application.otherElements
        }
        return elementQurey[label]
    }
    
    fileprivate func setup(_ application: XCUIApplication)
    {
        self.application = application
        //And/When/Then/But I tap the "Header" view
        MatchAll("^I tap (?:the )?\"([^\\\"]*)\" (button|label|tab|view|field|textView)$") { (args, userInfo) -> Void in
            let label = args?[0]
            let type = args?[1]
            self.elementByLabel(label!, type: type!).tap()
        }
        
        //And/When/Then/But I tap the "Increment" button 5 times
        MatchAll("^I tap (?:the )?\"([^\\\"]*)\" (button|label|tab|view) ([1-9]{1}) time(?:s)?$") { (args, userInfo) -> Void in
            let label = args?[0]
            let type = args?[1]
            let times = NSString(string: (args?[2])!).integerValue
            let element = self.elementByLabel(label!, type: type!)
            for _ in 0 ..< times{
                element.tap()
            }
        }
        //             Then I write "Ahmed Ali" into the "Name" field

        //When/And/But/When I write "Ahmed" in the "Name" field
        MatchAll("^I write \"([^\\\"]*)\" (?:into|in) (?:the )?\"([^\\\"]*)\" (field|text view)$") { (args, userInfo) -> Void in
            let type = args?[2]
            let label = args?[1]
            let element = self.elementByLabel(label!, type: type!)
            element.tap()
            element.typeText((args?[0])!)
        }
        
        //When/And/But/When I clear "Name" field
        MatchAll("^I clear (?:the )?\"([^\\\"]*)\" (field|text view)$") { (args, userInfo) -> Void in
            let type = args?[1]
            let label = args?[0]
            let testCase = userInfo?[kXCTestCaseKey] as? XCTestCase
            SStep(testCase, "I write \"\" into the \"\(label)\" \(type)$");
            
        }
        MatchAll("^I clear (?:the )?text and write \"([^\\\"]*)\" (?:into|in) (?:the )?\"([^\\\"]*)\" (field|text view)$") { (args, userInfo) -> Void in
            let type = args?[2]
            let label = args?[1]
            let string = args?[0]
            let testCase = userInfo?[kXCTestCaseKey] as? XCTestCase
            SStep(testCase, "I clear the \"\(label)\" \(type)")
            SStep(testCase, "I write \"\(string)\" into the \"\(label)\" \(type)");
        }
       
        MatchAll("^I should see \"(.*)\" in (?:the )?\"(.*)\" (view|field|label|button|text view)$") { (args, userInfo) -> Void in
            //I found XC UI very buggy in accessing current textual value on screen..
            //Any ideas will be very very helpful.
//            let type = args[2]
//            let label = args[1]
//            let value = args[0]
//            let element = self.elementByLabel(label, type: type)
//            var foundValue : AnyObject!
//            if(type == "label"){
//                foundValue = element.label;
//            }else{
//                foundValue = element.value as! String
//            }
//            CCISAssert(element.value != nil, "Could not find the \(type) with label \(label)");
//            
//            
//            CCISAssert(foundValue as! String == value , "Found \(type) with label \(label) but its value is \"\(foundValue)\" instead of \"\(value)\"");
        }
        
        
        
        MatchAll("^I switch (on|off) the \"([^\\\"]*)\" switch$") { (args, userInfo) -> Void in
            let theSwitch = application.switches[(args?[1])!]
            let currentValu = NSString(string: theSwitch.value as! String).integerValue
            let newValue = args?[0] == "on" ? 1 : 0
            if(currentValu != newValue){
                theSwitch.tap()
            }
            
        }
        
       
    }
    
    class func setup(_ application: XCUIApplication)
    {
        CCIStepDefinitions().setup(application)
    }
}
