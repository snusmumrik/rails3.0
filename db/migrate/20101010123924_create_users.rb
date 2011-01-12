class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users" do |t|
      t.string :login, :limit => 40
      t.string :name, :limit => 100, :default => '', :null => true
      t.string :email, :limit => 100
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at
      t.string :activation_code, :limit => 40
      t.datetime :activated_at
      t.string :password_reset_code, :limit => 40
      t.boolean :enabled, :default => true

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :users, :email, :unique => true

    #Be sure change the password later or in this migration file
    user = User.new
    user.login = "admin"
    user.name = "admin"
    user.email = "info@day-trippers.com"
    user.password = "admin"
    user.password_confirmation = "admin"
    user.save(:validate => false)
    user.send(:activate!)
  end

  def self.down
    drop_table "users"
  end
end
