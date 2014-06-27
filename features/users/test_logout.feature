Feature: Log Out
  A user currently signed in
  Should be able to sign out
  In order to protect himself from unauthorized access

    Scenario: User logs out
      Given I am logged in
      When I click the sign out button
      When I return to the sign in page
      Then I should be logged out
