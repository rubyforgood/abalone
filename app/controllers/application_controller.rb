class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :set_current_user

  helper_method def current_organization
    current_user.organization
  end

  # Auth check for Blazer reporting
  def require_organization
    redirect_to root_path unless current_user && current_organization
  end

  def set_current_user
    User.current = current_user
  end

  # Blazer's before_action_method call
  def blazer_setup
    require_organization
    set_current_user
  end
end
