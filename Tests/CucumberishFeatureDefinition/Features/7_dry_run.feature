@dry-run
Feature: 7 Dry Run
Cucumberish prints in the console the undefined steps

Background: Background Support
Given a Background Given statement which is undefined

Scenario: Dry Run - Given
Given a Given statement which is undefined
And an And statement which is undefined
When a When statement which is undefined
But a But statement which is undefined
Then a Then statement which is undefined
Then Cucumberish should print code snippets for these undefined steps in the console
