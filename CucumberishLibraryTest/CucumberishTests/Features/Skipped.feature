@skip
Feature: Skipped
As a user I expect this feature and all of its to be totally ignored

@run
Scenario: A dummy scneario to be skipped
Given it is home screen
And all data cleared
When I tap the "Profile" button
And I write "example@example.com" into the "Email" field
Then I write "Ahmed Ali" into the "Name" field
And I set the "Birthdate" picker date to "25-12-1990"
Then I tap "Save Profile" button
And I tap "Profile" button
Then I should see "Ahmed Ali" in the "Name" field
And I should see "example@example.com" in the "Email" field
