class Service < ActiveRecord::Base
  has_and_belongs_to_many :users, :class_name => "Person", :join_table => "services_users"
  
  def self.service_for_ticket(st)
    service_url = st.service
    Service.all.select { |s| service_url =~ /^#{s.url}/ }.first
  end
end
