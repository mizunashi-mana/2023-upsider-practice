class SessionsController < ApplicationController
  def get
    @user = session_user_authentication_with_finding(false)
    if @user.nil?
      return render json: {
        status: 'unauthorized',
      }
    end

    render json: {
      status: 'authorized',
      email: @user.email,
    }
  end

  def login
    @email = params.require(:email)
    @password = params.require(:password)

    @user = User.find_by(email: @email)
    if @user.nil?
      return render json: {
        result: 'fail'
      }
    end

    if !@user.authenticate(@password)
      return render json: {
        result: 'fail'
      }
    end

    set_user_in_session(@user.id)

    render json: {
      result: 'success'
    }
  end

  def logout
    @user_in_session = session_user_authentication
    if @user_in_session.nil?
      return
    end

    reset_session

    render json: {}
  end
end
