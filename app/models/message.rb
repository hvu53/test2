class Message
  # attr_accessible :title, :body
  include ActiveAttr::Model
  
  attribute :cname
  attribute :name
  attribute :email
  attribute :title
  attribute :subject
  attribute :content
  #attribute :priority # type: Integer, default: 0
  
  #attr_accessible :name, :email, :content

  validates_presence_of :cname
  validates_presence_of :name
  validates_presence_of :title
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_length_of :subject, :maximum => 255
  validates_length_of :content, :maximum => 500
end
