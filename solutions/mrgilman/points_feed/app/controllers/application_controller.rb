class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :validate_subdomain!

  def validate_subdomain!
    @subdomain = request.subdomain(Rails.configuration.SUBDOMAIN_INDEX)
    unless @subdomain.blank? or @subdomain == "www"
      @user = User.where("lower(display_name) = ?", @subdomain).first
      not_found if @user.nil?
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  include SessionsHelper
end
