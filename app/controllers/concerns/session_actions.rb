module SessionActions extend ActiveSupport::Concern
  def set_user_in_session(user_id)
    reset_session
    session[:user_id] = user_id
  end

  def session_user_authentication(render = true)
    @user_id = session[:user_id]
    if @user_id.nil?
      render status: :unauthorized if render
      return
    end

    return {
      id: @user_id
    }
  end

  def session_user_authentication_with_finding(render = true)
    @user_in_session = session_user_authentication(render)
    if @user_in_session.nil?
      return
    end

    @user = User.find_by(id: @user_in_session[:id])
    if @user.nil?
      logger.warn "Failed to find any users of session: user_id=#{@user_in_session[:id]}"
      render status: :internal_server_error if render
      return
    end

    return @user
  end
end
