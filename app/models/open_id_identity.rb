class OpenIdIdentity < ActiveRecord::Base
  belongs_to :person
  validates_uniqueness_of :identity_url
  devise :trackable
  
  def self.create_from_identity_url(identity_url)
    self.create(:identity_url => identity_url)
  end
end
