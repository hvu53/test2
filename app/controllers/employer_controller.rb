class EmployerController < ApplicationController
	before_filter :setup_nav
	def index
	end
	protected
	def setup_nav
		@topnav = 'employer'
	end
end
