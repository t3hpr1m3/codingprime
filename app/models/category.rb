# == Schema Information
# Schema version: 20100226030058
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  has_many :posts
  validates_presence_of :name
  validates_uniqueness_of :name

  before_create :add_slug

  private

  def add_slug
    str = self.name
    str = str.gsub( /[^a-zA-Z0-9\s]/, "" ).downcase
    str = str.gsub( /[\s]+/, " " )
    str = str.gsub( /\s/, "-" )
    self.slug = str
  end
end

