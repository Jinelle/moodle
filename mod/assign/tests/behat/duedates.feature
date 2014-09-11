@mod @mod_assign @javascript
Feature: A teacher can set a cut off date for an assignment
    In order to control when a student can upload an assignment
    As a teacher
    I need to set a cut off date for an assignment

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher1@example.com |
      | student1 | Student | 1 | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1 | weeks |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
    And I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "Assignment" to section "0" and I fill the form with:
      | Assignment name | Edited Assignment name |
      | Description | Edited Description |
      | id_duedate_day | 1 |
      | id_duedate_month | 1 |
      | id_duedate_year | 2030 |
      | id_duedate_hour | 12 |
      | id_duedate_minute | 05 |
      | id_cutoffdate_enabled | 1  |
      | id_cutoffdate_day | 1 |
      | id_cutoffdate_month | 1 |
      | id_cutoffdate_year | 2030 |
      | id_cutoffdate_hour | 12 |
      | id_cutoffdate_minute | 15 |
    And I should see "Edited Assignment name"
    And I log out

  Scenario: Assignment uploaded before due date
    Given I log in as "student1"
    And I follow "Course 1"
    And I follow "Edited Assignment name"
    When I should see "Time remaining"
    And I press "Add submission"
    And I upload "lib/tests/fixtures/empty.txt" file to "File submissions" filemanager
    And I press "Save changes"
    And I should see "Submitted for grading"
    And I log out
    And I log in as "teacher1"
    And I follow "Course 1"
    And I follow "Edited Assignment name"
    And I follow "View/grade all submissions"
    Then I should see "Submitted for grading"

  Scenario: Assignment uploaded after due date
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I open "Edited Assignment name" actions menu
    And I click on "Edit settings" "link" in the "Edited Assignment name" activity
    And I set the following fields to these values:
      | id_allowsubmissionsfromdate_year | 1990 |
      | id_duedate_year | 2000 |
    And I press "Save and return to course"
    And I log out
    When I log in as "student1"
    And I follow "Course 1"
    And I follow "Edited Assignment name"
    And I should see "Assignment is overdue by:"
    And I press "Add submission"
    And I upload "lib/tests/fixtures/empty.txt" file to "File submissions" filemanager
    And I press "Save changes"
    And I should see "Submitted for grading"
    And I log out
    And I log in as "teacher1"
    And I follow "Course 1"
    And I follow "Edited Assignment name"
    And I follow "View/grade all submissions"
    Then I should see "Submitted for grading"
    And I should see "days late"

  Scenario: Assignment uploaded after cutoff date
    Given I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I open "Edited Assignment name" actions menu
    And I click on "Edit settings" "link" in the "Edited Assignment name" activity
    And I set the following fields to these values:
      | id_allowsubmissionsfromdate_year | 1990 |
      | id_duedate_year | 2000 |
      | id_cutoffdate_year | 2005 |
    And I press "Save and return to course"
    And I log out
    When I log in as "student1"
    And I follow "Course 1"
    And I follow "Edited Assignment name"
    And I should see "Assignment is overdue by:"
    And "Add submission" "button" should not exist
    And I log out
    And I log in as "teacher1"
    And I follow "Course 1"
    And I follow "Edited Assignment name"
    And I follow "View/grade all submissions"
    Then I should see "No submission"
    And I should see "Assignment is overdue"
