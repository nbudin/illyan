class Person < ActiveRecord::Base
  devise :database_authenticatable, :openid_authenticatable, 
    :rememberable, :confirmable, :recoverable, :trackable, :registerable, :validatable
    
  # override Devise's password validations to allow password to be blank if legacy_password_md5 set
  protected
  def password_required?
    legacy_password_md5.blank? && super
  end
  
  public

  has_many :open_id_identities
  accepts_nested_attributes_for :open_id_identities, :allow_destroy => true
  validates_uniqueness_of :email, :allow_nil => true
  has_and_belongs_to_many :groups
  
  attr_accessible :firstname, :lastname, :gender, :birthdate, :email, :password
  
  def legacy_password_md5
    @legacy_password_md5 ||= if self.class.columns.include? "legacy_password_md5"
      read_attribute :legacy_password_md5
    end
  end
  
  def legacy_password_md5=(p)
    @legacy_password_md5 = p
    if self.class.columns.include? "legacy_password_md5"
      write_attribute :legacy_password_md5
    end
  end

  def delete_legacy_password!
    self.legacy_password_md5 = nil
  end

  def password=(password)
    super(password)
    delete_legacy_password!
  end

  def self.find_for_authentication(conditions)
    joins = if conditions[:identity_url]
      conditions["open_id_identities.identity_url"] = conditions.delete(:identity_url)
      :open_id_identities
    end
    
    find(:first, :conditions => conditions, :joins => joins)
  end
  
  def self.find_by_identity_url(identity_url)
    find(:first, :conditions => {:open_id_identities => {:identity_url => identity_url}}, :joins => :open_id_identities)
  end

  def valid_for_authentication?
    if !identity_url.blank?
      return true
    end

    super
  end

  def identity_url=(url)
    # just pass
  end
  
  # All users are their own admins
  #def has_role_with_self_admin?(role_name, object=nil)
  #  if role_name.to_s == "admin" && object == self
  #    true
  #  else
  #    has_role_without_self_admin?(role_name, object)
  #  end
  #end
  #alias_method_chain :has_role?, :self_admin
  
  # Add groups support to acl9's stock methods
  #def has_role_with_groups?(role_name, object=nil)
  #  has_role_without_groups?(role_name, object) or groups.any? {|group| group.has_role?(role_name, object)}
  #end
  #alias_method_chain :has_role?, :groups
  
  #def has_roles_for_with_groups?(object)
  #  has_roles_for_without_groups?(object) or groups.any? {|group| group.has_roles_for?(object)}
  #end
  #alias_method_chain :has_roles_for?, :groups
  
  #def roles_for_with_groups(object)
  #  roles = roles_for_without_groups(object)
  #  groups.each do |group|
  #    roles += group.roles_for(object)
  #  end
  #  return roles
  #end
  #alias_method_chain :roles_for, :groups

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
      {:email => email}
    end
    }
  end

  def identity_url
    open_id_identities.first.try(:identity_url)
  end
    
  def current_age
    age_as_of Date.today
  end
  
  def age_as_of(base = Date.today)
    if not birthdate.nil?
      base.year - birthdate.year - ((base.month * 100 + base.day >= birthdate.month * 100 + birthdate.day) ? 0 : 1)
    end
  end
  
  def confirmed_at_ymdhms
    confirmed_at.try(:strftime, "%Y-%m-%d %H:%M:%S")
  end
  
  def confirmed_at_ymdhms=(str)
    if str.blank?
      self.confirmed_at = nil
      generate_confirmation_token
    else
      self.confirmed_at = DateTime.strptime(str, "%Y-%m-%d %H:%M:%S")
    end
  end
  
  def name
    return "#{firstname} #{lastname}"
  end
end
