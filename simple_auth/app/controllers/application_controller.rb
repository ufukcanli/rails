class ApplicationController < ActionController::Base
  include Authentication

  delegate :user, to: :Current, prefix: "current"
  helper_method :current_user

  delegate :account, to: :Current, prefix: "current"
  helper_method :current_account

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
