class OpenIdIdentity < ActiveRecord::Base
  acts_as_ae_users_shared_model
  belongs_to :person
  validates_uniqueness_of :identity_url
end
