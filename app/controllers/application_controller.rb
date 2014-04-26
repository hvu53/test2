class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :setup_contact
  def setup_contact
  	@message = Message.new
  end
end
