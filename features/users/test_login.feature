Feature: Sign In
  As a user
  I need to be able to log in
  To access/view the contents of the website
  

  Scenario: User signs in successfully
    Given I exist as a user
      And I am not logged in
    When I sign in with valid credentials
    Then I am redirected to the queries page
    When I return to the sign in page
    Then I am redirected to the queries page

  Scenario: invalid username
    Given I am on the login page
      And I do not exist as a user
    When I provide the username "Testy McUserton"
    And I provide the password "changeme"
    Then I should not be able to log in

  Scenario: incorrect password
    Given I am on the login page
      And I exist as a user
    When I provide the username "Testy McUserton"
    And I provide the password "changemenot"
    Then I should not be able to log in


  Scenario: incorrect username
    Given I am on the login page
      And I exist as a user
    When I provide the username "Testy McUsertons"
    And I provide the password "changeme"
    Then I should not be able to log in
