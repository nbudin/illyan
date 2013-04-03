class Service < ActiveRecord::Base
  devise :token_authenticatable, :token_authentication_key => :service_token
  has_and_belongs_to_many :users, :class_name => "Person", :join_table => "services_users", :association_foreign_key => "user_id"
  before_create :ensure_authentication_token
  
  attr_accessible :name, :url, :logo_url, :description
  
  def self.service_for_url(url)
    Service.all.select { |s| url =~ /^#{s.url}/ }.first
  end
  
  def self.service_for_ticket(st)
    service_for_url(st.service)
  end
end
