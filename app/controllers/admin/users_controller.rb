class Admin::UsersController < AdminApplicationController
  before_filter :check_administrator_role
end
