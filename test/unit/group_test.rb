require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  subject { Factory(:group) }
  
  should have_and_belong_to_many(:people)
end
