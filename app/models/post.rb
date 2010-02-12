# == Schema Information
# Schema version: 20100211191224
#
# Table name: posts
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  body       :text
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Post < ActiveRecord::Base
	validates_presence_of :title, :body
	before_create :add_slug

	def url
		year = created_at.strftime( '%Y' )
		month = created_at.strftime( '%0m' )
		day = created_at.strftime( '%0d' )
		"/#{year}/#{month}/#{day}/#{slug}"
	end

	def self.create_slug( str )
		str = str.gsub( /[^a-zA-Z0-9\s]/, "" ).downcase
		str = str.gsub( /[\s]+/, " " )
		str = str.gsub( /\s/, "-" )
		str
	end

	private
		def add_slug
			self.slug = Post.create_slug( :title )
		end
end
