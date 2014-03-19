# == Schema Information
# Schema version: 20100816142128
#
# Table name: posts
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  body        :text
#  slug        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  category_id :integer
#

class Post < ActiveRecord::Base
  include SlugExtensions
  validates_presence_of :title, :body, :user_id
  belongs_to :user
  belongs_to :category
  has_many :comments

  scope :recent, -> { order(created_at: :desc) }

  before_create :add_slug

  def year
    created_at.strftime( "%Y" )
  end

  def month
    created_at.strftime( "%m" )
  end

  def day
    created_at.strftime( "%d" )
  end

  def url
    "/#{year}/#{month}/#{day}/#{slug}"
  end

  def slug_options
    {
      year: self.year,
      month: self.month,
      day: self.day,
      slug: self.slug
    }
  end

  private

  def add_slug
    self.slug = Post.generate_slug(self.title)
  end
end
