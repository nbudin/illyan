class Person < ActiveRecord::Base
  acts_as_illyan_shared_model
  acts_as_authorization_subject
  devise :trackable
  
  has_one :account
  has_many :open_id_identities
  has_many :permissions, :dependent => :destroy, :include => :permissioned
  has_many :email_addresses, :dependent => :destroy
  has_and_belongs_to_many :groups
  
  # Add groups support to acl9's stock methods
  def has_role_with_groups?(role_name, object=nil)
    has_role_without_groups?(role_name, object) or groups.any? {|group| group.has_role?(role_name, object)}
  end
  alias_method_chain :has_role?, :groups
  
  def has_roles_for_with_groups?(object)
    has_roles_for_without_groups?(object) or groups.any? {|group| group.has_roles_for?(object)}
  end
  alias_method_chain :has_roles_for?, :groups
  
  def roles_for_with_groups(object)
    roles = roles_for_without_groups(object)
    groups.each do |group|
      roles += group.roles_for(object)
    end
    return roles
  end
  alias_method_chain :roles_for, :groups

  def self.sreg_map  
    {:fullname => Proc.new do |fullname|
      if fullname =~ /^([^ ]+) +(.*)$/
        {:firstname => $1, :lastname => $2}
      else
        {:firstname => fullname}
      end
    end, 
    :dob => Proc.new do |dob|
      if dob =~ /^([0-9]{4})-([0-9]{2})-([0-9]{2})$/
        {:birthdate => Time.local($1, $2, $3)}
      else
        {}
      end
    end,
    :gender => Proc.new do |gender|
      if gender == 'M'
        {:gender => 'male'}
      elsif gender == 'F'
        {:gender => 'female'}
      else
        {}
      end
    end,
    :email => Proc.new do |email|
      {:primary_email_address => email}
    end
    }
  end
  
  def self.find_by_email_address(address)
    ea = EmailAddress.find_by_address(address)
    if not ea.nil?
      return ea.person
    end
  end
  
  def primary_email_address
    primary = email_addresses.find_by_primary true
    if not primary
      primary = email_addresses.find :first
    end
    if primary.nil?
      return nil
    else
      return primary.address
    end
  end
  
  def primary_email_address=(address)
    if primary_email_address != address
      ea = email_addresses.find_or_create_by_address(address)
      ea.primary = true
      ea.save
    end
  end
  
  def email
    primary_email_address && primary_email_address.address
  end
  
  def administrator_classes
    Illyan.authorization_object_classes.select do |c|
      has_role?("change_permissions_#{c.name.tableize}")
    end
  end
  
  def administrator?
    administrator_classes.length > 0
  end
  
  def current_age
    age_as_of Date.today
  end
  
  def age_as_of(base = Date.today)
    if not birthdate.nil?
      base.year - birthdate.year - ((base.month * 100 + base.day >= birthdate.month * 100 + birthdate.day) ? 0 : 1)
    end
  end
  
  def app_profile
    @app_profile ||= Illyan.profile_class.find_by_person_id(id)
  end
  
  def profile
    app_profile
  end
  
  def name
    return "#{firstname} #{lastname}"
  end
  
  if not Illyan.profile_class.nil?
    class_eval <<-END_CODE
    def #{Illyan.profile_class.name.tableize.singularize}
      app_profile
    end
    END_CODE
  end
  
  def has_role!(role_name, object=nil)
    role = get_role(role_name, object)
    
    if role.nil?
      role_attrs = case object
                   when Class then { :authorizable_type => object.to_s }
                   when nil then   {}
                   else            { :authorizable => object }
                   end.merge(      { :name => role_name.to_s })
      
      role = self._auth_role_class.create(role_attrs)
    end
    
    if role && !self.role_objects.exists?(role.id)
      role.people.add(self)
    end
  end
  
  private
  def delete_role(role)
    if role
      role.people.delete(self)
      
      role.destroy if role.send(self.class.to_s.demodulize.tableize).empty?
    end
  end
end
