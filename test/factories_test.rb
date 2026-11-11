require 'test_helper'

# Catches factories that have rotted, e.g. because the model or a method they
# rely on was removed.
class FactoriesTest < ActiveSupport::TestCase
  it "has only valid factories" do
    FactoryBot.lint
  end
end
