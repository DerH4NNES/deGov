@AnonymousUser
Feature: Startpage accessible
  As an anonymous user I should see the startpage

  Scenario: Anonymous user login
    Given I am an anonymous user
    Given I am on "/"
    Then I should see the link "Anmelden / Registrieren"
    When I click "Anmelden / Registrieren"
    Then I should be on "/user/login"

  @FooterMenuForAnonymousUser
  Scenario: Anonymous user sitemap
    Given I am an anonymous user
    Given I am on "/"
    When I click "Inhalt"
    Then I should see the link "Inhalt"
    Then I should be on "/sitemap"
