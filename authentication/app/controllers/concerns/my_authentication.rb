module MyAuthentication
  def require_authentication
    restore_authentication || request_authentication
  end

  def restore_authentication
    Current.user = User.find_by(id: cookies.signed[:user_id])
  end

  def request_authentication
    redirect_to new_session_path, notice: "You must be signed in to perform that action"
  end

  def sign_in(user)
    # Warning: This is not the final implementation and is currently insecure
    cookies.signed.permanent[:user_id] = user.id
  end
end
