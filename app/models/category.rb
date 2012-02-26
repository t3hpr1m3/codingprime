# == Schema Information
# Schema version: 20100816142128
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
  before_destroy :check_for_posts

  def to_param
    "#{slug}"
  end

  private

  def check_for_posts
    if posts.count > 0
      errors.add(:base, 'Cannot delete a category that has associated posts.')
      false
    end
  end

  def add_slug
    self.slug = Category.generate_slug( self.name )
  end
end
