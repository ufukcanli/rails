module Authentication
  # This line allows us to include this module in our controllers. The extend
  # ActiveSupport::Concern line is a Rails idiom that allows us to easily add other Rails features to
  # our module that we otherwise would not have access to, such as included and class_methods.
  extend ActiveSupport::Concern

  # This block of code is run when the module is included in a controller. It sets up a before_action to
  # run the require_authentication method before any controller action. It also makes the
  # authenticated? method available to the views.
  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  # This block of code is run when the module is included in a controller. It sets up a class_method to
  # allow unauthenticated access to specific controller actions (or all actions if none are listed).
  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

    def authenticated?
      resume_session
    end

    # This method is called before any controller action is run. It attempts to resume the session if it exists.
    # If it does not, it requests authentication.
    def require_authentication
      resume_session || request_authentication
    end

    # This method attempts to resume the session by finding the session in the database based on the
    # session ID stored in the cookie.
    def resume_session
      Current.session ||= find_session_by_cookie
    end

    # This method finds the session in the database based on the session ID stored in the cookie.
    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    # This method is called when the user is not authenticated. It stores the current URL in the session and
    # redirects the user to the login page.
    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    # This method is called after the user has authenticated. It redirects the user back to the URL they
    # were trying to access before they were redirected to the login page.
    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    # This method creates a new session for the user and stores it in the Current model. It also sets a
    # cookie with the session ID.
    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    # This method terminates the current session and deletes the session ID cookie.
    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
    end
end
