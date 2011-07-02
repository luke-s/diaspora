@javascript
Feature: posting
    In order to enlighten humanity for the good of society
    As a rock star
    I want to tell the world I am eating a yogurt
    
    Background:
      Given a user with username "bob"
      And a user with username "alice"
      When I sign in as "bob@bob.bob"
      And a user with username "bob" is connected with "alice"
      And I have an aspect called "PostTo"
      And I have an aspect called "DidntPostTo"
      And I have user with username "alice" in an aspect called "PostTo"
      And I have user with username "alice" in an aspect called "DidntPostTo"

      And I am on the home page

    Scenario: post to all aspects
      Given I expand the publisher
      When I fill in "status_message_fake_text" with "I am eating a yogurt"
        And I press "Share"
        And I follow "Your Aspects"
      Then I should see "I am eating a yogurt" within ".stream_element"

    Scenario: post a photo without text
      Given I expand the publisher
      And I attach the file "spec/fixtures/button.png" to hidden element "file" within "#file-upload"
      And I wait for the ajax to finish
      Then I should see an uploaded image within the photo drop zone
      And I press "Share"
      And I wait for the ajax to finish
      And I follow "Your Aspects"
      Then I should see a "img" within ".stream_element:first div.photo_attachments"
      Then I log out
      And I sign in as "alice@alice.alice"
      And I go to "bob@bob.bob"'s page
      Then I should see a "img" within ".stream_element:first div.photo_attachments"


    Scenario: post a photo with text
      Given I expand the publisher
      And I attach the file "spec/fixtures/button.png" to hidden element "file" within "#file-upload"
      And I fill in "status_message_fake_text" with "Look at this dog"
      And I press "Share"
      And I wait for the ajax to finish
      And I follow "Your Aspects"
      Then I should see a "img" within ".stream_element:first div.photo_attachments"
      And I should see "Look at this dog" within ".stream_element:first"
      Then I log out
      And I sign in as "alice@alice.alice"
      And I go to "bob@bob.bob"'s page
      Then I should see a "img" within ".stream_element:first div.photo_attachments"
      And I should see "Look at this dog" within ".stream_element:first"

    Scenario: hide a post
      Given I expand the publisher
      When I fill in "status_message_fake_text" with "Here is a post for you to hide"
        And I press "Share"
        And I wait for the ajax to finish

        And I log out
        And I sign in as "alice@alice.alice"
        And I am on "bob@bob.bob"'s page

        And I hover over the post
        And I click to delete the first post
        And I wait for the ajax to finish
        And I go to "bob@bob.bob"'s page
        Then I should not see "Here is a post for you to hide"
        And I am on the aspects page
        Then I should not see "Here is a post for you to hide"

    Scenario: delete a post
      Given I expand the publisher
      When I fill in "status_message_fake_text" with "I am eating a yogurt"
        And I press "Share"
        And I wait for the ajax to finish
        And I follow "Your Aspects"
        And I hover over the post
        And I preemptively confirm the alert
        And I click to delete the first post
        And I wait for the ajax to finish
        And I follow "Your Aspects"
        Then I should not see "I am eating a yogurt"

    Scenario Outline: post to one aspect
      When I follow "PostTo"
        And I wait for the ajax to finish
        And I expand the publisher
        And I fill in "status_message_fake_text" with "I am eating a yogurt"
        And I press "Share"
        And I am on the aspects page
        And I follow "<aspect>" within "#aspect_nav"
      Then I should <see> "I am eating a yogurt"

      Examples:
        | aspect      | see     |
        | PostTo      | see     |
        | DidntPostTo | not see |

    Scenario Outline: posting to all aspects from the profile page
      Given I am on "alice@alice.alice"'s page
        And I have turned off jQuery effects
        And I click "Mention" button
        And I expand the publisher in the modal window
        And I append "I am eating a yogurt" to the publisher
        And I press "Share" in the modal window
        And I am on the aspects page
        And I follow "<aspect>" within "#aspect_nav"
        Then I should <see> "I am eating a yogurt"

        Examples:
          | aspect      | see     |
          | PostTo      | see     |
          | DidntPostTo | see     |

    Scenario Outline: posting to one aspect from the profile page
      Given I am on "alice@alice.alice"'s page
        And I have turned off jQuery effects
        And I click "Mention" button
        And I expand the publisher in the modal window
        And I append "I am eating a yogurt" to the publisher
        And I follow "DidntPostTo" within "#publisher" in the modal window
        And I press "Share" in the modal window
        And I am on the aspects page
        And I follow "<aspect>" within "#aspect_nav"
        Then I should <see> "I am eating a yogurt"

        Examples:
          | aspect      | see     |
          | PostTo      | see     |
          | DidntPostTo | not see |
