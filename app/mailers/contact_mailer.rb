class ContactMailer < ActionMailer::Base
  FROM_ADDRESS = "Jiff.com <partners@jiff.com>"
  REPLY_TO = "Jiff.com <partners@jiff.com>"
  default :content_type => "text/html",
          :from => FROM_ADDRESS,
          :reply_to => REPLY_TO

  def new_message(message)
    @message = message
    mail(:to => "partners@jiff.com" ,:subject => "[from jiff.com] #{message.cname}")
  end
end
