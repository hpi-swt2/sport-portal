Feature: Sign up Input Validation
  As a user that inserts data into platform
  In order to know how to fill in the right data
  I want to have fill in support messages

  Scenario: First Name can't be blank
    Given a new user a with a blank first name field
    When a tries to sign up
    Then a should not be able to sign up
    And the page should show Vorname muss ausgefüllt werden

  Scenario: Last Name can't be blank
    Given a new user b with a blank last name field
    When b tries to sign up
    Then b should not be able to sign up
    And the page should show Nachname muss ausgefüllt werden

  Scenario Outline: Password should be secure
    Given a new user b with password <password>
    When b tries to sign up
    Then b should not be able to sign up
    And the page should show <error message>




  Examples:
  | password      | error message                                                 |
  |  a1s2d3f      |  Passwort ist zu kurz (weniger als 8 Zeichen)                 |
  |  123456789    |  Passwort darf nicht nur aus Zahlen bestehen                  |
  |  asdasdasdasd |  Passwort muss aus mindestens 4 verschiedenen Zeichen bestehen|
