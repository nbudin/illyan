class OpenIdIdentity < ActiveRecord::Base
  acts_as_illyan_shared_model
  belongs_to :person
  validates_uniqueness_of :identity_url
end
