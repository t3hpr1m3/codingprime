# == Schema Information
# Schema version: 20100211191224
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
#

require 'rdiscount'

class Post < ActiveRecord::Base
	validates_presence_of :title, :body
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

	private
		def add_slug
			str = self.title
			str = str.gsub( /[^a-zA-Z0-9\s]/, "" ).downcase
			str = str.gsub( /[\s]+/, " " )
			str = str.gsub( /\s/, "-" )
			self.slug = str
		end

		def render_body
			self.rendered_body = RDiscount.new( self.body ).to_html
		end
end
