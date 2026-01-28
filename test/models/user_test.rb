require "test_helper"
require "ostruct"

class UserTest < ActiveSupport::TestCase
  test "from_omniauth creates a user from linkedin data" do
    auth = OpenStruct.new(
      provider: "linkedin",
      uid: "123456",
      info: OpenStruct.new(
        email: "test@example.com",
        first_name: "John",
        last_name: "Doe",
        description: "Software Engineer",
        picture_url: "http://example.com/photo.jpg",
        location: "New York, NY",
        urls: { "public_profile" => "http://linkedin.com/in/johndoe" }
      )
    )

    assert_difference("User.count", 1) do
      User.from_omniauth(auth)
    end

    user = User.last
    assert_equal "test@example.com", user.email
    assert_equal "John", user.first_name
    assert_equal "Doe", user.last_name
    assert_equal "Software Engineer", user.title
    assert_equal "http://example.com/photo.jpg", user.photo_url
    assert_equal "New York, NY", user.location
    assert_equal "http://linkedin.com/in/johndoe", user.linkedinurl
    assert_equal "linkedin", user.provider
    assert_equal "123456", user.uid

    # Verify that repeated calls do not create duplicates
    assert_no_difference("User.count") do
      User.from_omniauth(auth)
    end
  end
end
