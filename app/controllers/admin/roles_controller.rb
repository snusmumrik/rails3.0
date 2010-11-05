class Admin::RolesController < AdminApplicationController
  before_filter :check_administrator_role
end
