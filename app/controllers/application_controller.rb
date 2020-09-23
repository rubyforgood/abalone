class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!

  helper_method def current_organization
    current_user.organization
  end
end
