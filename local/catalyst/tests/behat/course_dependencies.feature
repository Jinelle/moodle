@javascript @core @core_completions
Feature: Allow one course completion to be a dependency for completing another course
    In order for one course to be dependant of another
    As a student
    I need to be prevented from completing one course until the other is complete


    Background:
        Given the following "courses" exist:
        | fullname             | shortname | category | enablecompletion |
        | Completion course 1  | CC1       | 0        | 1                |
        | Completion course 2  | CC2       | 0        | 1                |
        | Completion course 3  | CC3       | 0        | 1                |
        | Completion course 4  | CC4       | 0        | 1                |
        | Noncompletion course | NC1       | 0        | 0                |
        And the following "users" exist:
        | username | firstname | lastname | email                |
        | student1 | Student   | First    | student1@example.com |
        And the following "course enrolments" exist:
        | user     | course | role    |
        | student1 | CC1    | student |
        | student1 | CC2    | student |
        | student1 | CC3    | student |
        Given I log in as "admin"
        # Enabling Course Completion site wide
        And I expand "Site administration" node
        And I follow "Advanced features"
        And I set the following fields to these values:
        | Enable completion tracking | 1 |
        | Enable conditional access | 1 |
        And I press "Save changes"
        And I am on homepage
        And I log out


    Scenario: Course with completion enabled site wide and no criteria set should not appear as dependency option
        Given I log in as "admin"
        When I follow "Completion course 2"
        And I follow "Course completion"
        And I click on "Condition: Completion of other courses" "text"
        # Checking course completion isn't enabled for the course
        And I should see "Course completion is not enabled for any other courses, so none can be displayed. You can enable course completion in the course settings."
        # Verifying the course criteria select box doesn't exist so cant be enabled
        Then "id_criteria_course" "select" should not exist


    Scenario: Course with completion enabled and criteria set appears as dependency option
        Given I log in as "admin"
        And I follow "Completion course 1"
        And I follow "Course completion"
        # Turning on a criteria in the course so I can use it as a dependency in another course
        And I set the following fields to these values:
        | id_criteria_self | 1 |
        And I press "Save changes"
        And I am on homepage
        When I follow "Completion course 2"
        And I follow "Course completion"
        And I click on "Condition: Completion of other courses" "text"
        And I set the following fields to these values:
        | Courses available  | Miscellaneous / Completion course 1 |
        Then the field "Courses available" does not match value "Noncompletion course"
        And I press "Save changes"


     Scenario: Do not allow a course to be set as a dependency of itself
        Given I log in as "admin"
        And I follow "Completion course 1"
        And I follow "Course completion"
        And I set the following fields to these values:
        | id_criteria_self | 1 |
        And I press "Save changes"
        And I am on homepage
        And I follow "Completion course 1"
        And I follow "Course completion"
        When I click on "Condition: Completion of other courses" "text"
        Then I should see "Course completion is not enabled for any other courses, so none can be displayed. You can enable course completion in the course settings."
        And "id_criteria_course" "select" should not exist



     Scenario: Student completes course when it's dependency is complete
        Given I log in as "admin"
        And I follow "Completion course 1"
        And I turn editing mode on
        And I add the "Self completion" block
        And I add the "Course completion status" block
        # Editing the course settings
        And I follow "Edit settings"
        And I set the following fields to these values:
        | Enable completion tracking | 1 |
        And I press "Save changes"
        And I follow "Course completion"
        # Setting manual self completion. The user will complete in the self completion block
        And I click on "Condition: Manual self completion" "text"
        # Turning on a criteria in the course so I can use it as a dependency in another course
        And I set the following fields to these values:
        | id_criteria_self | 1 |
        And I press "Save changes"
        And I am on homepage
        # Navigating to course 2
        And I follow "Completion course 2"
        And I add the "Course completion status" block
        And I follow "Course completion"
        And I set the following fields to these values:
        | Courses available  | Miscellaneous / Completion course 1 |
        And I press "Save changes"
        And I log out
        # Logging in as student 1
        When I log in as "student1"
        And I follow "Completion course 2"
        # Tracking the users status in the course by looking for tests in the completion status block
        And I should see "Status: Not yet started" in the ".block_completionstatus" "css_element"
        And I am on homepage
        And I follow "Completion course 1"
        And I should see "Status: Not yet started" in the ".block_completionstatus" "css_element"
        And I follow "Complete course"
        And I press "Yes"
        # Triggering cron to show status as complete
        And I trigger cron
        And I am on homepage
        # Going back into Course to see if it is complete
        And I follow "Completion course 1"
        And I should see "Status: Complete" in the ".block_completionstatus" "css_element"
        And I am on homepage
        # Since the first course is complete, the only criteria for course 2 was course 1. So it should be marked as complete too.
        Then I follow "Completion course 2"
        # Triggering cron to show status as complete
        And I trigger cron
        And I am on homepage
        # Going back into Course to see if it is complete
        And I follow "Completion course 2"
        And I should see "Status: Complete" in the ".block_completionstatus" "css_element"

      
     Scenario: Student completes course when multiple required dependencies are complete. Course 3 is dependent on course 1 & 2.
        Given I log in as "admin"
        And I follow "Completion course 1"
        And I turn editing mode on
        And I add the "Self completion" block
        And I add the "Course completion status" block
        And I follow "Course completion"
        # Turning on a criteria in course 1 so I can use it as a dependency in another course
        And I set the following fields to these values:
        | id_criteria_self | 1 |
        And I press "Save changes"
        And I am on homepage
        And I follow "Completion course 2"
        And I add the "Self completion" block
        And I add the "Course completion status" block
        And I follow "Course completion"
        # Turning on a criteria in course 2 so I can use it as a dependency in another course
        And I set the following fields to these values:
        | id_criteria_self | 1 |
        And I press "Save changes"
        And I am on homepage
        And I follow "Completion course 3"
        And I add the "Course completion status" block
        And I follow "Course completion"
        And I set the following fields to these values:
        | Courses available  | Miscellaneous / Completion course 1, Miscellaneous / Completion course 2 |
        | Condition requires | ALL selected courses to be completed
        And I press "Save changes"
        And I log out
        # Logging in as student1
        When I log in as "student1"
        # Navigating to course 3 to verify that the course hasn't been completed
        And I follow "Completion course 3"
        And I should see "Status: Not yet started" in the ".block_completionstatus" "css_element"
        And I am on homepage
        And I follow "Completion course 2"
        # Verifying course hasn't yet been completed
        And I should see "Status: Not yet started" in the ".block_completionstatus" "css_element"
        # Marking the course as complete
        And I follow "Complete course"
        # Triggering the cron
        And I press "Yes"
        And I trigger cron
        And I am on homepage
        And I follow "Completion course 2"
        And I should see "Status: Complete" in the ".block_completionstatus" "css_element"
        And I am on homepage
        # Navigating to course 3 to check that it's in progress
        And I follow "Completion course 3"
        And I should see "Status: In progress" in the ".block_completionstatus" "css_element"
        And I am on homepage
        # Navigating back to course 1 to mark the course as complete
        And I follow "Completion course 1"
        And I should see "Status: Not yet started" in the ".block_completionstatus" "css_element"
        And I follow "Complete course"
        And I press "Yes"
        And I trigger cron
        And I trigger cron
        # Navigating back to the course and verifying that the course is complete
        And I am on homepage
        And I follow "Completion course 1"
        And I should see "Status: Complete" in the ".block_completionstatus" "css_element"
        And I am on homepage
        Then I follow "Completion course 3"
        And I should see "Status: Complete" in the ".block_completionstatus" "css_element"


    Scenario: Student completes course which is a dependency of a course they are not enrolled in
        Given I log in as "admin"
        And I follow "Completion course 1"
        And I turn editing mode on
        And I add the "Self completion" block
        And I add the "Course completion status" block
        And I follow "Course completion"
        # Turning on a criteria in course 1 so I can use it as a dependency in another course
        And I set the following fields to these values:
        | id_criteria_self | 1 |
        And I press "Save changes"
        And I am on homepage
        And I follow "Completion course 4"
        And I add the "Course completion status" block
        And I follow "Course completion"
        And I set the following fields to these values:
        | Courses available  | Miscellaneous / Completion course 1 |
        And I press "Save changes"
        And I log out
        # Logging in as student 1
        When I log in as "student1"
        And I follow "Completion course 1"
        # Verifying that the course hasn't yet been started
        And I should see "Status: Not yet started" in the ".block_completionstatus" "css_element"
        And I follow "Complete course"
        And I press "Yes"
        And I trigger cron
        # Navigating back to the course and verifying that the course is complete
        And I am on homepage
        And I follow "Completion course 1"
        And I should see "Status: Complete" in the ".block_completionstatus" "css_element"


    Scenario: After resetting completion this criteria should recomplete
        Given I log in as "admin"
        And I follow "Completion course 1"
        And I turn editing mode on
        And I add the "Self completion" block
        And I add the "Course completion status" block
        And I follow "Course completion"
        # Turning on a criteria so I can use it as a dependency in another course
        And I set the following fields to these values:
        | id_criteria_self | 1 |
        And I press "Save changes"
        And I am on homepage
        And I follow "Completion course 2"
        And I add the "Self completion" block
        And I add the "Course completion status" block
        And I follow "Course completion"
        # Turning on a criteria so I can use it as a dependency in another course
        And I set the following fields to these values:
        | id_criteria_self | 1 |
        And I set the following fields to these values:
        | Courses available  | Miscellaneous / Completion course 1 |
        And I press "Save changes"
        And I log out
        # Logging in as student 1
        And I log in as "student1"
        And I follow "Completion course 1"
        And I follow "Complete course"
        And I press "Yes"
        And I trigger cron
        And I trigger cron
        # Navigating back to the course and verifying that the course is complete
        And I am on homepage
        And I follow "Completion course 1"
        And I should see "Status: Complete" in the ".block_completionstatus" "css_element"
        And I am on homepage
        And I follow "Completion course 2"
        # And I should see "Status: Complete" in the ".block_completionstatus" "css_element"
        And I log out
        # Logging in as admin
        When I log in as "admin"
        And I follow "Completion course 2"
        And I follow "Course completion"
        And I press "Unlock completion options and delete user completion data"
        And I press "Save changes"
        And I log out
        # Logging in as student 1
        And I log in as "student1"
        And I follow "Completion course 2"
        And I should see "Status: Pending" in the ".block_completionstatus" "css_element"
        And I trigger cron
        Then I am on homepage
        And I follow "Completion course 2"
        And I should see "Status: Complete" in the ".block_completionstatus" "css_element"



    Scenario: Student completes course which is a dependency of a course they are not enrolled in
        Given I log in as "admin"
        And I follow "Completion course 1"
        And I turn editing mode on
        And I add the "Self completion" block
        And I add the "Course completion status" block
        And I follow "Course completion"
        And I set the following fields to these values:
        | id_criteria_self | 1 |
        And I press "Save changes"
        And I am on homepage
        And I follow "Completion course 4"
        And I add the "Course completion status" block
        And I follow "Course completion"
        And I set the field "id_criteria_course" to "Completion course 1"
        And I press "Save changes"
        And I log out
        When I log in as "student1"
        And I follow "Completion course 1"
        And I should see "Status: Not yet started" in the ".block_completionstatus" "css_element"
        And I follow "Complete course"
        And I press "Yes"
        And I trigger cron
        And I am on homepage
        And I follow "Completion course 1"
        Then I should see "Status: Complete" in the ".block_completionstatus" "css_element"


    

    Scenario: On enrolment in course this criteria should complete when dependency is complete


    Scenario: On enrolment in course this criteria shouldn't complete when dependency is incomplete
