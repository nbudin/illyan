require 'test_helper'

class Admin::PeopleControllerTest < ActionController::TestCase
  setup do
    @admin = FactoryBot.create(:administrator)
    @person = FactoryBot.create(:joe_user)
  end

  describe "without authentication" do
    it "redirects anonymous visitors to the login page" do
      get :index
      assert_redirected_to new_person_session_path
    end
  end

  describe "as a regular person" do
    setup { sign_in FactoryBot.create(:person).tap(&:confirm) }

    it "denies access to the people list" do
      get :index
      assert_response :success
      assert_template "shared/access_denied"
    end

    it "does not allow updating other people" do
      patch :update, params: { id: @person.id, person: { firstname: "Hacked" } }
      assert_template "shared/access_denied"
      assert_equal "Joe", @person.reload.firstname
    end
  end

  describe "as an administrator" do
    setup { sign_in @admin }

    it "lists people" do
      get :index
      assert_response :success
      assert_includes assigns(:people), @person
    end

    it "searches people" do
      other = FactoryBot.create(:person, firstname: "Zebediah", lastname: "Quux")
      get :index, params: { q: "Zebediah" }
      assert_response :success
      assert_includes assigns(:people), other
      refute_includes assigns(:people), @person
    end

    it "shows a person as HTML" do
      get :show, params: { id: @person.id }
      assert_response :success
      assert_select "h1", text: @person.name
      assert_select "dd", text: "Unprivileged"
    end

    it "shows an administrator's access level" do
      get :show, params: { id: @admin.id }
      assert_response :success
      assert_select "dd", text: "Administrator"
    end

    it "shows a person as JSON" do
      get :show, params: { id: @person.id, format: :json }
      assert_response :success
      assert_equal "joe@user.com", JSON.parse(response.body)["email"]
    end

    it "renders the new, edit, edit_account and change_password forms" do
      get :new
      assert_response :success
      %i[edit edit_account change_password].each do |action|
        get action, params: { id: @person.id }
        assert_response :success, "expected #{action} to render"
      end
    end

    it "updates a person" do
      patch :update, params: { id: @person.id, person: { firstname: "Joseph" } }
      assert_redirected_to admin_person_url(@person)
      assert_equal "Joseph", @person.reload.firstname
    end

    it "re-renders the form when an update is invalid" do
      patch :update, params: { id: @person.id, person: { email: "" } }
      assert_response :success
      assert_template :edit
    end
  end

  describe "as a service using an API token" do
    setup do
      @service = FactoryBot.create(:service)
      request.headers["Authorization"] = ActionController::HttpAuthentication::Token.encode_credentials(@service.authentication_token)
    end

    # Characterization: #create has a branch for adding people to the current
    # service, but `require_admin!` rejects services first, so it is unreachable.
    it "is not allowed to create people, despite #create having a service-specific branch" do
      post :create, params: { person: { email: @person.email } }, format: :json
      assert_response :forbidden
      refute_includes @person.reload.services, @service
    end

    it "is not allowed to list people" do
      get :index, format: :json
      assert_response :forbidden
    end

    it "is not allowed to update people" do
      patch :update, params: { id: @person.id, person: { firstname: "Nope" } }, format: :json
      assert_response :forbidden
      assert_equal "Joe", @person.reload.firstname
    end
  end
end
