class Person < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  devise :database_authenticatable, :legacy_md5_authenticatable, :legacy_sha1_authenticatable,
    :rememberable, :confirmable, :recoverable, :trackable, :registerable, :validatable, :invitable
    
  cattr_reader :per_page
  @@per_page = 20
  
  index_name Illyan::Application.index_name
  
  settings :analysis => {
    :filter => {
       :ngrams  => {
         "type"     => "nGram",
         "max_gram" => 10,
         "min_gram" => 1 
       }
     },
     :analyzer => {
       :substring => {
         :tokenizer => "keyword",
         :filter => ["lowercase", "ngrams"],
         :type => "custom"
       },
       :email_substring => {
         :tokenizer => "uax_url_email",
         :filter => ["lowercase", "ngrams"],
         :type => "custom"
       },
       :lowercase => {
         :tokenizer => "standard",
         :filter => ["lowercase"],
         :type => "custom"
       },
       :email_lowercase => {
         :tokenizer => "uax_url_email",
         :filter => ["lowercase"],
         :type => "custom"
       }
     }
  }
  
  mapping do
    indexes :id, :type => 'string', :index => :not_analyzed
    indexes :firstname, :type => 'string'
    indexes :lastname, :type => 'string'
    indexes :email, :type => 'string'
    
    indexes :firstname_ngrams, :type => 'string', :index_analyzer => 'substring', :search_analyzer => 'lowercase'
    indexes :lastname_ngrams, :type => 'string', :index_analyzer => 'substring', :search_analyzer => 'lowercase'
    indexes :email_ngrams, :type => 'string', :index_analyzer => 'email_substring', :search_analyzer => 'email_lowercase'
  end
  
  # override Devise's password validations to allow password to be blank if legacy_password_md5 set
  protected
  def password_required?
    return false if skip_password_required
    
    if !legacy_password_md5.blank? || invitation_token.present?
      false
    else
      super
    end
  end
  
  public

  validates_uniqueness_of :email, :allow_nil => true
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :services, :foreign_key => :user_id, :join_table => "services_users"
  
  attr_accessor :skip_password_required
  
  def delete_legacy_password!
    self.legacy_password_md5 = nil
  end

  def password=(password)
    super(password)
    delete_legacy_password!
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
  
  def fallback_name
    email
  end
  
  def name
    if firstname.present? || lastname.present?
      "#{firstname} #{lastname}".strip
    else
      fallback_name
    end
  end
  
  def inverted_name
    if firstname.present? && lastname.present?
      "#{lastname}, #{firstname}"
    else
      fallback_name
    end
  end
  
  def to_xml(options = {})
    options[:include] ||= []
    options[:include] << :services unless options[:include].include?(:services)
    super(options)
  end
  
  def headers_for(action)
    case action.to_sym
    when :invitation, :invitation_instructions
      { :subject => if services.size == 1
        "#{services.first.name} Invitation"
        else
          "#{ENV['ILLYAN_SITE_TITLE']} Invitation"
        end
      }
    else
      {}
    end
  end
  
  def as_indexed_json(options={})
    {
      firstname: firstname,
      lastname: lastname,
      email: email,
      birthdate: birthdate,
      gender: gender,
      firstname_ngrams: firstname,
      lastname_ngrams: lastname
    }.as_json
  end
end
