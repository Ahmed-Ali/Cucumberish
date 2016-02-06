Pod::Spec.new do |s|

  s.name         = "Cucumberish"
  s.version      = "0.0.5"
  s.summary      = "Cucumberish is an automated test framework for iOS and Mac OS X that uses the most possible human friendly language to define your automated test cases"
  s.description  = <<-DESC
    Cucumberish is Objective-C and Swift framework for Behaviour Driven Development inspired by the amazing way of writing automated test cases introduced originally by Cucumber. With Cucumberish, you write your test cases in almost plain English language.
                   DESC
  s.homepage     = "https://github.com/Ahmed-Ali/Cucumberish"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Ahmed Ali" => "eng.ahmed.ali.awad@gmail.com" }
  s.social_media_url   = "https://www.linkedin.com/in/engahmedali"
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :git => "https://github.com/Ahmed-Ali/Cucumberish.git", :tag => "v#{s.version}"}
  s.source_files  = 'Cucumberish/*.{h,m}', 'Cucumberish/Core/Managers/*.{h,m}', 'Cucumberish/Core/Models/*.{h,m}', 'Cucumberish/Utils/*.{h,m}', 'Cucumberish/Dependencies/Gherkin', 'Cucumberish/Core/CCIBlockDefinitions.h'
  s.public_header_files = 'Cucumberish/Cucumberish.h', 'Cucumberish/Core/Managers/CCIStepsManager.h', 'Cucumberish/Core/CCIBlockDefinitions.h', 'Cucumberish/Core/Models/CCIScenarioDefinition.h'
  s.resource_bundles = {
    'Gherkin' => ['Cucumberish/Dependencies/Gherkin/gherkin-languages.json'],
  }
  s.framework  = "XCTest"
  s.requires_arc = true
  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => "SRC_ROOT=$(SRCROOT)" }
end
