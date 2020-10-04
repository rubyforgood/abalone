class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :set_current_user

  helper_method def current_organization
    current_user.organization
  end

  def authorize_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end

  # Auth check for Blazer reporting
  def require_organization
    redirect_to root_path unless current_user && current_organization
  end

  def set_current_user
    User.current = current_user
  end

  # Blazer's before_action_method call to
  # make sure a user is logged in and associated
  # with an organization as the app does.
  def blazer_setup
    require_organization
    set_current_user
  end
end
