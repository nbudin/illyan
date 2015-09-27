class Service < ActiveRecord::Base
  has_and_belongs_to_many :users, :class_name => "Person", :join_table => "services_users", :association_foreign_key => "user_id"
  before_create :ensure_authentication_token
  
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
  
  def urls_delimited
    urls.try(:join, "\n") || ""
  end
  
  def urls_delimited=(delimited_urls)
    self.urls = delimited_urls.split(/[\r\n]+/)
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Service.where(authentication_token: token).first
    end
  end
end
