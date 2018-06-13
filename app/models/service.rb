class Service < ActiveRecord::Base
  has_and_belongs_to_many :users, :class_name => "Person", :join_table => "services_users", :association_foreign_key => "user_id"
  belongs_to :oauth_application, class_name: "Doorkeeper::Application", dependent: :destroy
  before_create :ensure_authentication_token
  after_save :sync_oauth_application

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

  def sync_oauth_application
    oauth_application_attributes = {
      name: name,
      redirect_uri: urls.select { |url| url.start_with?('https:') || url.start_with?('http://localhost') }
    }
    return unless oauth_application_attributes[:redirect_uri].any?

    if oauth_application
      oauth_application.update! oauth_application_attributes
    else
      create_oauth_application! oauth_application_attributes
      save!
    end
  end
end
