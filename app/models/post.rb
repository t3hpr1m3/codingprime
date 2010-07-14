# == Schema Information
# Schema version: 20100226030058
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
  attr_accessible :title, :body

  before_create :add_slug

  def to_param
    "#{slug}"
  end

  def approved_comments
    self.comments.find( :all, :conditions => 'approved="t"', :order => 'created_at ASC' )
  end

  def rejected_comments
    self.comments.find( :all, :conditions => 'approved="f"', :order => 'created_at ASC' )
  end

  def year
    created_at.strftime( '%Y' )
  end

  def month
    created_at.strftime( '%0m' )
  end

  def day
    created_at.strftime( '%0d' )
  end

  def url
    "/#{year}/#{month}/#{day}/#{slug}"
  end

  private
    def add_slug
      self.slug = generate_slug( self.title )
    end
end
