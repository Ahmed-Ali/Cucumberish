@run @history
Feature: History
As a user I want to see record of history when a profile is created/updated and activity is added/deleted

Scenario: Create profile and see the action in history
    Given it is home screen
    And all data cleared

#First create a profile
    When I tap the "Profile" button
    And I write "example@example.com" into the "Email" field
    Then I write "Ahmed Ali" into the "Name" field
    And I set the "Birthdate" picker date to "25-12-1990"
    Then I tap "Save Profile" button
    
#Then update the profile
    When I tap the "Profile" button
    And I clear the text and write "eng.ahmed.ali.awad@gmail.com" into the "Email" field
    Then I tap "Save Profile" button

#Then add an activity
    Then I tap the "Add Activity" button
    And I write "Current activity" into the "Activity Name" field
    And I tap "Increment" button 2 times
    Then I switch on the "Currently Happening" switch
    And I tap "Activity Add" button

#Then delete the added activity
    And I tap "Activities" button
    Then I swipe left the row 0 in section 0 in "Activities List" table
    And I tap "Delete" button
    And I tap "Nav Back" button
    Then I tap "History" button

#Confirm the four history item exist and has the right value
    Then I should see 4 rows at section 0 in "History" table
    And I should see "Profile Created" at row 0 section 0 in "History" table
    And I should see "Profile Updated" at row 1 section 0 in "History" table
    And I should see "Added a current activity" at row 2 section 0 in "History" table
    And I should see "Deleted a current activity" at row 3 section 0 in "History" table
    
