class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :role_id, :user_id, :null => false
      t.timestamps
    end

    role = Role.find_by_name('administrator')
    user = User.find_by_login('admin')
    permission = Permission.new
    permission.role = role
    permission.user_id = user.id
    permission.save(false)
  end

  def self.down
    drop_table :permissions
  end
end
