class Service < ActiveRecord::Base
  devise :token_authenticatable
  has_and_belongs_to_many :users, :class_name => "Person", :join_table => "services_users", :association_foreign_key => "user_id"
  before_create :ensure_authentication_token
  
  def self.service_for_url(url)
    Service.all.select { |s| url =~ /^#{s.url}/ }.first
  end
  
  def self.service_for_ticket(st)
    service_for_url(st.service)
  end
end
