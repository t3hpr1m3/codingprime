# == Schema Information
# Schema version: 20100215170027
#
# Table name: posts
#
#  id            :integer         not null, primary key
#  title         :string(255)
#  body          :text
#  rendered_body :text
#  slug          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#

require 'rdiscount'

class Post < ActiveRecord::Base
	validates_presence_of :title, :body, :user_id
	belongs_to :user
	attr_accessible :title, :body

	before_create :add_slug
	before_save :render_body

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

	def self.render_markdown( text )
		RDiscount.new( text ).to_html
	end

	private
		def add_slug
			str = self.title
			str = str.gsub( /[^a-zA-Z0-9\s]/, "" ).downcase
			str = str.gsub( /[\s]+/, " " )
			str = str.gsub( /\s/, "-" )
			self.slug = str
		end

		def render_body
			self.rendered_body = Post.render_markdown( self.body )
		end
end
