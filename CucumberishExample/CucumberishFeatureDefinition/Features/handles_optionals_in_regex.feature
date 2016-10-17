Feature: Optionals In Regex
Cucumberish shall allow optionals in a regex

Scenario: Optionals
Given a step
And a step has an optional match "foobar"
When cucumber is executed
Then the step "a step" had no match for the optional parameter
And the step "a step" had "foobar" matched for the optional parameter

