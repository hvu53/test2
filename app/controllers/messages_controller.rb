class MessagesController < ApplicationController
	def new
		@message = Message.new
	end

	def create
		@message = Message.new(params[:message])
    if @message.valid?
      # TODO send message here
      ContactMailer.new_message(@message).deliver
      respond_to do |format|
	       format.js { 
	        return render :js => "alertify.success( 'Your message was sent');" 
	       }
      end
    else
      #render "new"
      
    	@message.errors.full_messages.each do |msg|
    		respond_to do |format|
           format.js { 
            return render :js => "alertify.error('Please fill out your name and valid email');" 
           }
        end 
      end  
    end
	end
end
