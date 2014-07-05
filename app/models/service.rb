class Service < ActiveRecord::Base
  has_and_belongs_to_many :users, :class_name => "Person", :join_table => "services_users", :association_foreign_key => "user_id"
  before_create :ensure_authentication_token
  
  attr_accessible :name, :url, :logo_url, :description, :public
  
  def self.service_for_url(url)
    Service.all.select { |s| url =~ /^#{s.url}/ }.first
  end
  
  def self.service_for_ticket(st)
    service_for_url(st.service)
  end
   
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Service.where(authentication_token: token).first
    end
  end
end
