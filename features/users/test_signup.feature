Feature: Sign up
  As a future user
  I want to be able to sign up
  And access the contents of the site

  Scenario: Visitor is able sign up with a valid email and password
    Given I am not signed up
    When I provide a valid username and password
    Then I have signed in successfully

  Scenario: Visitor cannot sign up without providing a password
    Given I am not signed up
    When I provide a username
    And I do not provide a password
    Then I am unable to sign up

  Scenario: Visitor cannot sign up when passwords do not match
    Given I am not signed up
    When I provide a username
    And my passwords do not match
    Then I am unable to sign up

  Scenario: Visitor cannot sign up when confirm password is empty
    Given I am not signed up
    When I provide a username
    And I provide a password
    And I do not confirm my password
    Then I am unable to sign up

  Scenario: Visitor needs a password of atleast 8 characters
    Given I am not signed up
    When I provide a username
    And I provide a password of less than 8 characters
    And I confirm the same
    Then I am unable to sign up
