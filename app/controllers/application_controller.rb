class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale  

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  unless Rails.env.development?
  # Develop環境で404を出すやつ
  # unless Rails.env.production?
    rescue_from Exception,                      with: :render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end
 
  def routing_error
    raise ActionController::RoutingError, params[:path]
  end
 
  private
 
  def render_404
    render 'errors/404', status: :not_found
  end
 
  def render_500
    render 'errors/500', status: :internal_server_error
  end
end
