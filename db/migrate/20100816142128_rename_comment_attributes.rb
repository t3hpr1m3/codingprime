class RenameCommentAttributes < ActiveRecord::Migration
  def self.up
    rename_column :comments, :user_name, :author_name
    rename_column :comments, :user_site, :author_site
    rename_column :comments, :user_email, :author_email
    rename_column :comments, :user_ip, :author_ip
    rename_column :comments, :user_agent, :author_user_agent
  end

  def self.down
    rename_column :comments, :author_name, :user_name
    rename_column :comments, :author_site, :user_site
    rename_column :comments, :author_email, :user_email
    rename_column :comments, :author_ip, :user_ip
    rename_column :comments, :author_user_agent, :user_agent
  end
end
