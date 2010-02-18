class RemoveRenderedBodyFromPost < ActiveRecord::Migration
  def self.up
    remove_column :posts, :rendered_body
  end

  def self.down
    add_column :posts, :rendered_body, :text
  end
end
