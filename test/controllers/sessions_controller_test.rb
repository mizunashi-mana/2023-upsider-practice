require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should work login/get/logout" do
    post api_sessions_login_url, params: {
      email: 'user1@example.com',
      password: 'pass1'
    }
    assert_response :success
    assert_equal(
      {
        'result' => 'success',
      },
      JSON.parse(@response.body),
    )

    get api_sessions_get_url
    assert_response :success
    assert_equal(
      {
        'status' => 'authorized',
        'email' => 'user1@example.com',
      },
      JSON.parse(@response.body),
    )

    post api_sessions_logout_url
    assert_response :success
  end

  test "should reject login with wrong password" do
    post api_sessions_login_url, params: {
      email: 'user1@example.com',
      password: 'wrong'
    }
    assert_response :success
    assert_equal(
      {
        'result' => 'fail',
      },
      JSON.parse(@response.body),
    )
  end

  test "should return unathorized without login by get" do
    get api_sessions_get_url
    assert_response :success
    assert_equal(
      {
        'status' => 'unauthorized',
      },
      JSON.parse(@response.body),
    )
  end

  test "should reject without login by logout" do
    post api_sessions_logout_url
    assert_response :unauthorized
  end
end
