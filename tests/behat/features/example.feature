Feature: Duo BLT smoke testing
  As an anonymous user
  I should be able to navigate through website pages using Nav buttons


  Scenario: Open home page and find text
    Given I am on "http://duo-blt.docksal"
    Then I should see text matching "Please login"
    When I follow "Create new account"
    Then I should see text matching "Create New Account"
    When I follow "Reset your password"
    Then I should see text matching "Username or email address"
