class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params[:user])
    @user.account = Account.new(user_params[:account])

    if @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "Registration successful."
    else
      render :new
    end
  end

  private

    def user_params
      u, a = params.expect(user: [ :name, :email_address, :password, :password_confirmation ], account: [ :name ])
      { user: u, account: a }
    end
end
