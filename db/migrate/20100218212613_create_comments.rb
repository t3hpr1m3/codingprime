class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :user_name
      t.string :user_site
      t.string :user_email
      t.text :comment_text
      t.string :user_ip
      t.string :user_agent
      t.string :referrer
      t.references :post
      t.boolean :approved

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
