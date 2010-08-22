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
  include SlugExtensions
  has_many :posts
  validates_presence_of :name
  validates_uniqueness_of :name

  before_create :add_slug

  def recent_posts
    posts.recent
  end

  def to_param
    "#{slug}"
  end

  private

  def add_slug
    self.slug = Category.generate_slug( self.name )
  end
end

