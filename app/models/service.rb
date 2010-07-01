class Service < ActiveRecord::Base
  has_and_belongs_to_many :users, :class_name => "Person", :join_table => "services_users"
  
  def self.service_for_url(url)
    Service.all.select { |s| url =~ /^#{s.url}/ }.first
  end
  
  def self.service_for_ticket(st)
    service_for_url(st.service)
  end
end
