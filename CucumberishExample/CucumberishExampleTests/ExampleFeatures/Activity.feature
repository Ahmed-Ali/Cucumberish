Feature: Activity
As a user I should be able to add some activites, and delete them

Scenario: Add an activity
    Given it is home screen
    And all data cleared
    Then I tap the "Add Activity" button
    And I write "First Ended Activity" into the "Activity Name" field
    When I tap "Increment" button 5 times
    Then I should see "6" in the "TheRank" label
    Then I switch off the "Currently Happening" switch
    Then I tap "Activity Add" button
    When I tap "Activities" button
# Done like that intentionally to be a failure example
    Then I should see "First Ended Activity (5)" at row 0 section 1 in "Activities List" table

Scenario: Preparing for multible adding
    Given it is home screen
    And all data cleared

Scenario Outline: Adding activities
    Given it is home screen
    When I tap the "Add Activity" button
    And I write "<name>" into the "Activity Name" field
    When I tap "Increment" button <rankPlusOne> times
    Then I should see "<TheRank>" in the "TheRank" label
    Then I switch <currentOnOff> the "Currently Happening" switch
    Then I tap "Activity Add" button

Examples:
    |     name     | rankPlusOne | TheRank | currentOnOff |
    |  Activity 1  |      4      |     5     |      on      |
    |  Activity 2  |      5      |     6     |      on      |
    |  Activity 3  |      4      |     5     |      on      |
    |  Activity 4  |      3      |     4     |      on      |
    |  Activity 5  |      4      |     5     |      off     |
    |  Activity 6  |      2      |     3     |      off     |

Scenario: Validating added activities
    Given it is home screen
    When I tap "Activities" button
    Then I should see 4 rows at section 0 in "Activities List" table
    But I should see 2 rows at section 1 in "Activities List" table

Scenario: Deleting activities
    Given it is home screen
    And all data cleared
    When I tap "Activities" button
    Then I should see 0 rows at section 0 in "Activities List" table
    And I should see 0 rows at section 0 in "Activities List" table
    When I tap "Nav Back" button

    And I tap "Add Activity" button
    Then I write "Activity 1" into the "Activity Name" field
    And I tap "Increment" button 3 times
    Then I switch off the "Currently Happening" switch
    And I tap "Activity Add" button

    Then I tap "Add Activity" button
    And I write "Activity 2" into the "Activity Name" field
    And I tap "Increment" button 1 time
    Then I switch on the "Currently Happening" switch
    Then I tap "Activity Add" button

    Then I tap "Add Activity" button
    And I write "Activity 3" into the "Activity Name" field
    And I tap "Increment" button 5 times
    Then I switch on the "Currently Happening" switch
    And I tap "Activity Add" button

    And I tap "Activities" button
    Then I should see 2 rows at section 0 in "Activities List" table
    But I should see 1 rows at section 1 in "Activities List" table

    Then I swipe left the row 0 in section 0 in "Activities List" table
    And I tap "Delete" button
    Then I should see 1 row at section 0 in "Activities List" table
