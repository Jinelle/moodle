@mod @mod_forum @javascript @advancedgrading @grading
Feature: Enable self-grading in forum
  In order to make sure grade link appears and fucntions correctly
  As a student
  I need to create a forum discussion and follow the "Grade" link

Background:
    Given the following "courses" exist:
        | fullname | shortname | category |
        | Course 1 | C1 | 0 |
    And the following "users" exist:
        | username | firstname | lastname | email |
        | student1 | Student | 1 | student1@asd.com |
    And the following "course enrolments" exist:
        | user | course | role |
        | student1 | C1 | student |
    And I log in as "admin"
    And I follow "Course 1"
    And I turn editing mode on


Scenario: Add forum discussion to check grading link doesn't appear
    Given I add a "Forum" to section "1" and I fill the form with:
        | Forum name | Test forum name |
        | Description | Test forum description |
        |  Forum type | Standard forum for general use |
    And I log out
    When I log in as "student1"
    And I follow "Course 1"
    And I add a new discussion to "Test forum name" forum with:
        | Subject | Pretend subject message |
        | Message | This is the body |
    Then "Grade" "link" should not be visible


Scenario: Checking grading link appears when settings are changed
    Given I add a "Forum" to section "1" and I fill the form with:
        | Forum name | Test forum name |
        | Description | Test forum description |
        | Forum type | Standard forum for general use |
        | Overall forum participation | Marking guide |
        | Individual posts | No grade |
        | Self grading | Yes |
    And I follow "Test forum name"
    And I expand "Advanced grading" node
    And I expand "Overall forum participation" node
    And I follow "Define marking guide"
    And I set the following fields to these values:
        | Name | Test marking guide |
    And I add a marking criteria with these values:
        | shortname          | This is a short name         |
        | description        | This is a description        |
        | descriptionmarkers | This is a description marker |
        | maxscore           | 100                          |
    And I press "Save marking guide and make it ready"
    And I click on "Publish the form as a new template" "text"
    And I press "Continue"
    And I log out
    And I log in as "student1"
    And I follow "Course 1"
    And I add a new discussion to "Test forum name" forum with:
        | Subject | This is a test subject |
        | Message | This is the body |
    And I reply "This is a test subject" post from "Test forum name" forum with:
        | Subject | First reply |
        | Message | This a reply. It should show in the body |
    And "Grade" "link" should be visible
    And I add a new discussion to "Test forum name" forum with:
        | Subject | Second subject |
        | Message | Second body |
    And I reply "Second subject" post from "Test forum name" forum with:
        | Subject | Second subject |
        | Message | This a reply. It should show in the body |
    And "Grade" "link" should be visible
    And I follow "Grade"
    And "First reply" "text" should be visible
    And "Second subject" "text" should be visible
    And I fill in forum marking criteria with these values:
        | remark | This is a remark |
        | score  | 100 |
    And I press "Save changes"
    And I follow "Second subject"
    And I expand "Course administration" node
    And I follow "Grades"
    And I should see "Test forum name"
    And I should see "100.00"


Scenario: Checking grade link appears and works when settings are changed
    Given I add a "Forum" to section "1" and I fill the form with:
        | Forum name                  | Test forum name                |
        | Description                 | Test forum description         |
        | Forum type                  | Standard forum for general use |
        | Overall forum participation | No grade                       |
        | Individual posts            | Marking guide                  |
        | Self grading                | Yes                            |
    And I follow "Test forum name"
    And I expand "Advanced grading" node
    And I expand "Individual posts" node
    And I follow "Define marking guide"
    And I set the following fields to these values:
        | Name | Test marking guide |
    And I add a marking criteria with these values:
        | shortname          | This is a short name         |
        | description        | This is a description        |
        | descriptionmarkers | This is a description marker |
        | maxscore           | 100                          |
    And I press "Save marking guide and make it ready"
    And I click on "Publish the form as a new template" "text"
    And I press "Continue"
    And I log out
    And I log in as "student1"
    And I follow "Course 1"
    And I add a new discussion to "Test forum name" forum with:
        | Subject | This is a test subject |
        | Message | This is the body |
    And I reply "This is a test subject" post from "Test forum name" forum with:
        | Subject | First reply |
        | Message | This a reply. It should show in the body |
    And "Grade" "link" should be visible
    And I add a new discussion to "Test forum name" forum with:
        | Subject | Second subject |
        | Message | Second body |
    And I reply "Second subject" post from "Test forum name" forum with:
        | Subject | Second subject |
        | Message | This a reply. It should show in the body |
    And "Grade" "link" should be visible
    And I follow "Grade"
    And "Second subject" "text" should be visible
    And I should not see "First reply"
    And I fill in forum marking criteria with these values:
        | remark | This is a remark |
        | score  | 100 |
    And I press "Save changes"
    And I expand "Course administration" node
    And I follow "Grades"
    And I should see "Test forum name"
    And I should see "100.00"


Scenario: Checking Grade link functions when settings are changed
    Given I add a "Forum" to section "1" and I fill the form with:
        | Forum name                  | Test forum name                |
        | Description                 | Test forum description         |
        | Forum type                  | Standard forum for general use |
        | Overall forum participation | Rubric                       |
        | Individual posts            | Marking guide                  |
        | Self grading                | Yes                            |
    And I follow "Test forum name"
    And I expand "Advanced grading" node
    And I expand "Individual posts" node
    And I follow "Define marking guide"
    And I set the following fields to these values:
        | Name | Test marking guide |
    And I add a marking criteria with these values:
        | shortname          | This is a short name         |
        | description        | This is a description        |
        | descriptionmarkers | This is a description marker |
        | maxscore           | 100                          |
    And I press "Save marking guide and make it ready"
    And I click on "Publish the form as a new template" "text"
    And I press "Continue"
    And I log out
    And I log in as "student1"
    And I follow "Course 1"
    And I add a new discussion to "Test forum name" forum with:
        | Subject | This is a test subject |
        | Message | This is the body |
    And I reply "This is a test subject" post from "Test forum name" forum with:
        | Subject | First reply |
        | Message | This a reply. It should show in the body |
    And "Grade" "link" should be visible
    And I add a new discussion to "Test forum name" forum with:
        | Subject | Second subject |
        | Message | Second body |
    And I reply "Second subject" post from "Test forum name" forum with:
        | Subject | Second subject |
        | Message | This a reply. It should show in the body |
    And "Grade" "link" should be visible
    And I follow "Grade"
    And "Second subject" "text" should be visible
    And I should not see "First reply"
    And I fill in forum marking criteria with these values:
        | remark | This is a remark |
        | score  | 100 |
    And I press "Save changes"
    And I expand "Course administration" node
    And I follow "Grades"
    And I should see "Test forum name"
    And I should see "100.00"
