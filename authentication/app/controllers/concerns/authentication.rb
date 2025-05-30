module Authentication
  def sign_in(user)
    # Warning: This is not the final implementation and is currently insecure
    cookies.permanent[:user_id] = user.id
  end
end
