require "test_helper"

class ContactTest < ActiveSupport::TestCase
  test "should save basic contact" do
    contact = Contact.new(name: "John Doe", email: "john.doe@lexdrel.com")
    assert contact.save
  end
end
