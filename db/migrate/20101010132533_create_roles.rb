class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :rolename

      t.timestamps
      t.datetime :deleted_at
    end
  end

  def self.down
    drop_table :roles
  end
end