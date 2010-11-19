require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  fixtures :users

  setup do
    @role = roles(:one)
  end

  test "should get index" do
    login_as :quentin
    get :index, :user_id => users(:quentin).id
    assert_response :success
    assert_not_nil assigns(:all_roles)
  end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end
  
  # test "should create role" do
  #   assert_difference('Role.count') do
  #     post :create, :role => @role.attributes
  #   end
  
  #   assert_redirected_to role_path(assigns(:role))
  # end
  
  # test "should show role" do
  #   get :show, :id => @role.to_param
  #   assert_response :success
  # end
  
  # test "should get edit" do
  #   get :edit, :id => @role.to_param
  #   assert_response :success
  # end

  test "should update role" do
    login_as :quentin
    put :update, :user_id => users(:quentin).id, :id => @role.to_param, :role => @role.attributes
    assert_redirected_to roles_path
  end

  test "should destroy role" do
    login_as :quentin
    delete :destroy, :id => @role.to_param, :user_id => users(:quentin).id
    assert_equal users(:quentin).roles, []

    assert_redirected_to roles_path
  end
end
