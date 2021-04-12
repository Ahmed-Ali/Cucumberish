Pod::Spec.new do |s|

  s.name         = "Cucumberish"
  s.version      = "1.3.0"
  s.summary      = "Cucumberish is the native Objective-C implementation of Cucumber BDD automation test framework"
  s.description  = <<-DESC
    Cucumberish is Objective-C and Swift framework for Behaviour Driven Development inspired by the amazing way of writing automated test cases introduced originally by Cucumber. With Cucumberish, you write your test cases in almost plain English language.
                   DESC
  s.homepage     = "https://github.com/Ahmed-Ali/Cucumberish"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Ahmed Ali" => "eng.ahmed.ali.awad@gmail.com" }
  s.social_media_url   = "https://www.linkedin.com/in/engahmedali"
  s.ios.deployment_target = "7.0"
  s.tvos.deployment_target = "9.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :git => "https://github.com/Ahmed-Ali/Cucumberish.git", :tag => "v#{s.version}"}

  s.source_files  = 'Sources/*.{h,m}', 'Sources/Core/Managers/*.{h,m}', 'Sources/Core/Models/*.{h,m}', 'Sources/Utils/*.{h,m}', 'Sources/Dependencies/Gherkin', 'Sources/Core/CCIBlockDefinitions.h'
  s.public_header_files =
    'Sources/Cucumberish.h',
    'Sources/Core/CCIBlockDefinitions.h',
    'Sources/Core/CCILogManager.h',
    'Sources/Core/Managers/CCIStepsManager.h',
    'Sources/Core/Models/CCIArgument.h',
    'Sources/Core/Models/CCIBackground.h',
    'Sources/Core/Models/CCIExample.h',
    'Sources/Core/Models/CCIFeature.h',
    'Sources/Core/Models/CCILocation.h',
    'Sources/Core/Models/CCIScenarioDefinition.h',
    'Sources/Core/Models/CCIStep.h'
  s.resource_bundles = {
    'GherkinLanguages' => ['Sources/Dependencies/Gherkin/gherkin-languages.json'],
  }

  s.framework  = "XCTest"
  s.requires_arc = true
  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => "SRC_ROOT=@\\\"$(SRCROOT)\\\"" }
end
