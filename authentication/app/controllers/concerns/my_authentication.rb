module MyAuthentication
  def require_authentication
    restore_authentication || request_authentication
  end

  def restore_authentication
    if session = session_from_cookies
      Current.user = session.user
    end
  end

  def request_authentication
    redirect_to new_session_path, notice: "You must be signed in to perform that action"
  end

  def sign_in(user)
    session = user.sessions.create!
    cookies.signed.permanent[:session_id] = { value: session.id, httponly: true }
  end

  def session_from_cookies
    Session.find_by(id: cookies.signed[:session_id])
  end

  def sign_out
    session_from_cookies.destroy!
    cookies.delete(:session_id)
  end

  def redirect_if_signed_in
    if restore_authentication
      redirect_to root_path, notice: "You are already signed in."
    end
  end
end
