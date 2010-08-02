require 'test_helper'

class OpenIdIdentityTest < ActiveSupport::TestCase
  subject { Factory(:open_id_identity) }
  
  should belong_to(:person)
  should validate_uniqueness_of(:identity_url)
end
