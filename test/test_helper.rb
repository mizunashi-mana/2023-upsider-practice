ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  USER_PASS = {
    'user1@example.com' => 'pass1',
    'user2@example.com' => 'pass2',
    'user3@example.com' => 'pass3',
  }

  # Add more helper methods to be used by all tests here...
  def login_by_user(email, password = nil)
    @password = if password.nil?
      USER_PASS[email]
    else
      password
    end

    post api_sessions_login_url,
      params: {
        email: email,
        password: @password,
      }
    assert_response :success
    @login_response = JSON.parse(@response.body)
    assert_equal 'success', @login_response['result']
  end
end
