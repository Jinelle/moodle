@core @core_question
Feature: A teacher can choose from 11 different question types when creating a question
  In order use multiple types of questions
  As a teacher
  I need to be able to choose different question types

  Scenario: Create a question
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher1@asd.com |
    And the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1 | weeks |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
    When I log in as "teacher1"
    And I follow "Course 1"
    And I add a "True/False" question filling the form with:
      | Question name | Test True/False Question |
      | Question text | Is this true? |
      | Default mark | 1 |
    Then I should see "Question bank"
    And I should see "Test True/False Question"
    And I should see "Teacher 1" in the "td.creatorname" "css_element"
    And I should see "Teacher 1" in the "td.modifiername" "css_element"
