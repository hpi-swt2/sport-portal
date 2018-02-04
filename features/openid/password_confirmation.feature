Feature:
  No password confirmation needed for OpenID-users

  Scenario: Visit account settings with linked OpenID-account
    Given a user with a linked OpenID account
    And the user is logged in
    When he views his account settings
    Then there should not be an input 'Passwort'

  Scenario: Change account data attempt
    Given a user with a linked OpenID account
    And the user is logged in
    When he views his account settings
    And he changes his email
    And the user submits the form
    And the page should show 'Deine Daten wurden aktualisiert'
