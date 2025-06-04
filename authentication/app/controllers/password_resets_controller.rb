class PasswordResetsController < ApplicationController
  before_action :redirect_if_signed_in

  def new
  end

  def create
    if user = User.find_by(email: param[:email])
      # 1. Generate the unique token
      # 2. Deliver it via email
      redirect_to root_path, notice: "Email sent with password reset instructions."
    else
      flash.now[:notice] = "No user found with that email address"
      render :new, status: :unprocessable_entity
    end
  end
end
