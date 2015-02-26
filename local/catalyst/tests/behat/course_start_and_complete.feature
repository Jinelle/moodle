@javascript @core @core_completions
Feature: Allow teachers to track students starting and completing courses
    In order for teachers to track students progress
    As a student
    I need to be able to start and completion courses

    Background:
        Given the following "courses" exist:
        | fullname          | shortname | category |
        | Completion course | CC1       | 0        |
        And the following "users" exist:
        | username | firstname | lastname | email                |
        | student1 | Student   | First    | student1@example.com |
        And the following "course enrolments" exist:
        | user     | course | role    |
        | student1 | CC1    | student |


    Scenario: Start and complete a course with completion enabled
        And I log in as "admin"
        # Enabling Course Completion site wide
        And I expand "Site administration" node
        And I follow "Advanced features"
        And I set the following fields to these values:
        | Enable completion tracking | 1 |
        | Enable conditional access | 1 |
        And I press "Save changes"
        And I am on homepage
        # Navigating to the course
        And I follow "Completion course"
        And I follow "Edit settings"
        And I set the following fields to these values:
        | Enable completion tracking | 1 |
        And I press "Save changes" 
        # Editing course completion settings
        And I follow "Course completion"
        And I set the following fields to these values:
        | id_criteria_self | 1 |
        And I press "Save changes"
        And I turn editing mode on
        # Adding self completion blockcomp
        And I add the "Self completion" block
        # Adding course completion status block
        And I add the "Course completion status" block
        And I log out
        # Logging in as a student
        When I log in as "student1"
        And I follow "Completion course"
        And I should see "Status: Not yet started"
        And I follow "Complete course"
        And I press "Yes"
        And I am on homepage
        And I follow "Completion course"
        And I trigger cron
        And I am on homepage
        # Going back into Course to see if it is complete
        And I follow "Completion course"
       Then I should see "Status: Complete"


     Scenario: Do not start a course with completion disabled site-wide
        Given I log in as "admin"
        And I am on homepage
        And I follow "Completion course"
        And I turn editing mode on
        And I add the "Self completion" block
        And I add the "Course completion status" block
        And I log out
        Then I log in as "admin"
        And I follow "Completion course"
        And I should see "Completion is not enabled for this site"
        And I follow "Edit settings"
        And I should not see "Enable completion tracking"


    Scenario: Do not start a course with completion disabled in the course
        Given I log in as "admin"
        And I expand "Site administration" node
        And I follow "Advanced features"
        And I set the following fields to these values:
        | Enable completion tracking | 1 |
        | Enable conditional access | 1 |
        And I press "Save changes"
        And I am on homepage
        And I follow "Completion course"
        And I turn editing mode on
        And I add the "Self completion" block
        And I add the "Course completion status" block
        And I follow "Edit settings"
        And I set the following fields to these values:
        | Enable completion tracking | 0 |
        And I press "Save changes"
        Then I should see "Completion is not enabled for this course"
