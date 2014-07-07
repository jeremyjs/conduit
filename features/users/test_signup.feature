Feature: Sign up
  As a future user
  I want to be able to sign up
  And access the contents of the site

  Scenario: Visitor is able sign up with a valid email and password
    Given I am not signed up
    When I provide a username
    And I provide a valid email
    And I provide a valid password
    And I confirm the same
    And I click the sign up button
    Then I have signed in successfully

  Scenario: Visitor cannot sign up without providing a password
    Given I am not signed up
    When I provide a username
    And I provide a valid email
    And I do not provide a password
    And I click the sign up button
    Then I am unable to sign up

  Scenario: Visitor cannot sign up when passwords do not match
    Given I am not signed up
    When I provide a username
    And I provide a valid email
    And my passwords do not match
    And I click the sign up button
    Then I am unable to sign up

  Scenario: Visitor cannot sign up when confirm password is empty
    Given I am not signed up
    When I provide a username
    And I provide a valid email
    And I provide a valid password
    And I do not confirm my password
    And I click the sign up button
    Then I am unable to sign up

  Scenario: Visitor needs a password of atleast 8 characters
    Given I am not signed up
    When I provide a username
    And I provide a valid email
    And my password and its confirmation are less than 8 characters
    And I click the sign up button
    Then I am unable to sign up

  Scenario: Visitor needs to provide an email
    Given I am not signed up
    When I provide a username
    And I do not provide an email
    And I provide a valid password
    And I confirm the same
    When I click the sign up button
    Then I am unable to sign up

  Scenario: Visitor's email needs to provide a valid email
    Given I am not signed up
    When I provide a username
    And I do not provide a valid email
    And I provide a valid password
    And I confirm the same
    When I click the sign up button
    Then I am unable to sign up
