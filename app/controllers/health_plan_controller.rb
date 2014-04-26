class HealthPlanController < ApplicationController
	before_filter :setup_nav
	def index
		redirect_to employer_index_path and return
	end

	def setup_nav
		@topnav = 'health_plan'
	end
end
