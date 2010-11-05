class Admin::PermissionsController < AdminApplicationController
  before_filter :check_administrator_role
end
