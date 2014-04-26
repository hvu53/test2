class PartnerController < ApplicationController
	before_filter :setup_nav
	def index
	end
	
	def setup_nav
		@topnav = 'partner'
	end
end
