require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  setup do
    @service = FactoryBot.create(:service)
    @person = FactoryBot.create(:person, :admin => true)
    @person.confirm
    sign_in @person
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service" do
    assert_difference('Service.count') do
      post :create, params: { service: { name: "My new service", urls_delimited: 'https://google.com' } }
    end

    assert_redirected_to services_path
  end

  test "should get edit" do
    get :edit, params: { id: @service.to_param }
    assert_response :success
  end

  test "should update service" do
    put :update, params: { id: @service.to_param, service: @service.attributes }
    assert_redirected_to services_path
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      delete :destroy, params: { id: @service.to_param }
    end

    assert_redirected_to services_path
  end
end
