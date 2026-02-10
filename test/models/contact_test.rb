require "test_helper"

class ContactTest < ActiveSupport::TestCase
  test "should save basic contact and transition to mailed" do
    contact = Contact.new(name: "John Doe", email: "john.doe@lexdrel.com")
    assert contact.save
    # after_create_commit triggers the email and transition
    assert_equal "mailed", contact.current_state
    assert_equal "mailed", contact.status
  end

  test "transitions to awaiting and contacted" do
    contact = Contact.create(name: "Work Flow", email: "flow@lexdrel.com")
    assert_equal "mailed", contact.current_state

    contact.transition_to!(:awaiting)
    assert_equal "awaiting", contact.current_state
    assert_equal "awaiting", contact.reload.status

    contact.transition_to!(:contacted)
    assert_equal "contacted", contact.current_state
  end

  test "should delete contact and associated states" do
    contact = Contact.create(name: "Delete Me", email: "delete@lexdrel.com")
    assert_difference("Contact.count", -1) do
      assert_difference("ContactState.count", -1) do # only 'mailed' state is persisted
        contact.destroy
      end
    end
  end
end
