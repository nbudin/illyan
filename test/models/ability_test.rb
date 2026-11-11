require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  describe "an anonymous visitor" do
    it "can't do anything" do
      ability = Ability.new(nil)
      assert ability.cannot?(:read, Person.new)
      assert ability.cannot?(:admin, :site)
    end
  end

  describe "a regular person" do
    setup do
      @person = FactoryBot.create(:joe_user)
      @ability = Ability.new(@person)
    end

    it "can read, update, and destroy only themselves" do
      other = FactoryBot.create(:person)
      %i[read update destroy edit_account change_password].each do |action|
        assert @ability.can?(action, @person), "should be able to #{action} self"
        assert @ability.cannot?(action, other), "should not be able to #{action} others"
      end
    end

    it "can't administer the site or manage services" do
      assert @ability.cannot?(:admin, :site)
      assert @ability.cannot?(:create, Service)
      assert @ability.cannot?(:list, Person)
    end
  end

  describe "an administrator" do
    setup do
      @admin = FactoryBot.create(:administrator)
      @ability = Ability.new(@admin)
    end

    it "can administer the site" do
      assert @ability.can?(:admin, :site)
    end

    it "can manage any person and any service" do
      person = FactoryBot.create(:person)
      %i[list read create update destroy edit_account change_password].each do |action|
        assert @ability.can?(action, person), "should be able to #{action} Person"
      end
      %i[list read create update destroy].each do |action|
        assert @ability.can?(action, Service.new), "should be able to #{action} Service"
      end
    end
  end

  describe "a service" do
    setup do
      @service = FactoryBot.create(:service)
      @ability = Ability.new(@service)
    end

    it "can read and create people" do
      assert @ability.can?(:read, Person.new)
      assert @ability.can?(:create, Person)
    end

    it "can't update or destroy people" do
      person = FactoryBot.create(:person)
      assert @ability.cannot?(:update, person)
      assert @ability.cannot?(:destroy, person)
    end

    it "can read only itself, and can't administer the site" do
      assert @ability.can?(:read, @service)
      assert @ability.cannot?(:read, FactoryBot.create(:service))
      assert @ability.cannot?(:admin, :site)
    end
  end
end
