require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  def test_should_activate_user
    assert_nil User.authenticate('aaron@example.com', 'monkey')
    get :show, :id => users(:aaron).activation_code
    assert_redirected_to '/signin'
    assert_not_nil flash[:notice]
    assert_equal users(:aaron), User.authenticate('aaron@example.com', 'monkey')
  end
  
  def test_should_not_activate_user_without_key
    get :show
    assert_equal flash[:notice], "Activation code not found. Please try creating a new account."
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :show, :activation_code => ''
    assert_equal flash[:notice], "Activation code not found. Please try creating a new account."
  rescue ActionController::RoutingError
    # well played, sir
  end
end
