require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  subject { FactoryGirl.create(:group) }
  
  should have_and_belong_to_many(:people)
end
