@run
Feature: Profile
As a user I should be able to create profile and update my details

Scenario: Create profile
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

@skip
Scenario: Scenario that should be completely ignored
    Given it is home screen
    When I tap the "Profile" button
    And I clear the text and write "eng.ahmed.ali.awad@gmail.com" into the "Email" field
    Then I tap "Save Profile" button
    And I tap "Profile" button
    Then I should see "Ahmed Ali" in the "Name" field
    And I should see "eng.ahmed.ali.awad@gmail.com" in the "Email" field

Scenario: Update profile
    Given it is home screen
    When I tap the "Profile" button
    And I clear the text and write "eng.ahmed.ali.awad@gmail.com" into the "Email" field
    Then I tap "Save Profile" button
    And I tap "Profile" button
    Then I should see "Ahmed Ali" in the "Name" field
    And I should see "eng.ahmed.ali.awad@gmail.com" in the "Email" field


