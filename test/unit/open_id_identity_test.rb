require 'test/test_helper'

class OpenIdIdentityTest < ActiveSupport::TestCase
  subject { Factory(:open_id_identity) }
  
  should_belong_to :person
  should_validate_uniqueness_of :identity_url
end
