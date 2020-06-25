class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_action :authenticate_user!
  before_action :authenticate_user!

  before_action :find_setting

  def find_setting
    @setting = Setting.first || Setting.new
  end
end
