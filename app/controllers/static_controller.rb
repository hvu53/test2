class StaticController < ApplicationController
	before_filter :setup_nav
	def about
	end

	def careers
	end

	def faq
	end

	def news
	end

	def team
	end

	def rightnav
		render :partial => "/shared/rightnav"
	end

	def setup_nav
		@topnav = 'static'
	end
end
