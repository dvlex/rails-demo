require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "new_contact_form" do
    mail = ContactMailer.new_contact_form("to@example.org", "Test User")
    assert_equal "Thank you for contacting us", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "noreply@lexdrel.com" ], mail.from
    assert_match "Thank you for getting in touch with us through Lexdrel.com.", mail.body.encoded
  end
end
