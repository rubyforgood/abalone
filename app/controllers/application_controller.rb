class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
end
