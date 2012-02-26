class ModifyUserFields < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :encrypted_password
      t.remove :salt
      t.string :password_digest
    end
  end
end
