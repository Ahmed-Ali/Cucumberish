Pod::Spec.new do |s|

  s.name         = "Cucumberish"
  s.version      = "0.0.1"
  s.summary      = "Cucumberish is an automated test tool for iOS that uses the most possible human friendly language to define your automated test scenarios"
  s.description  = <<-DESC
    Cucumberish is a native Objective-C framework for Behaviour Driven Development inspired by the amazing way of writing automated test cases introduced originally by Cucumber.
    With Cucumberish, you write your test scenarios using the well known Gherkin syntax, and implement the scenario steps using native Objective-C or Swift syntax and enjoy full Xcode integration with Test Navigator that shows your test cases and failures exactly like native XCTestCase(s).
                   DESC
  s.homepage     = "https://github.com/Ahmed-Ali/Cucumberish"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Ahmed Ali" => "eng.ahmed.ali.awad@gmail.com" }
  s.social_media_url   = "https://www.linkedin.com/in/engahmedali"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Ahmed-Ali/Cucumberish.git", :tag => "v0.0.1"}
  s.source_files  = 'Cucumberish/*.{h,m}', 'Cucumberish/Core/Managers/*.{h,m}', 'Cucumberish/Core/Models/*.{h,m}', 'Cucumberish/Utils/*.{h,m}', 'Cucumberish/Dependencies/Gherkin'
  s.public_header_files = 'Cucumberish/Cucumberish.h', 'Cucumberish/Core/Managers/CCIStepsManager.h', 'Cucumberish/Core/CCIBlockDefinitions.h', 'Cucumberish/Core/Models/CCIScenarioDefinition.h'
  s.resource_bundles = {
    'Gherkin' => ['Cucumberish/Dependencies/Gherkin/gherkin-languages.json'],
  }
  s.framework  = "XCTest"
  s.requires_arc = true
  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => "SRC_ROOT=$(SRCROOT)" }
end
