@javascript @core @core_completion 
Feature: After resetting course criteria recalculatable criteria should recomplete
    In order for teachers to fix mistakes with criteria
    As an admin
    I need student's recalcualtable criteria to recomplete after resetting course criteria
    
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
        
        
  Scenario: Resetting course critera and recalculating student's score
        
   
   
          
           
