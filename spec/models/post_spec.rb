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

require 'spec_helper'

describe Post do
	before(:each) do
		@post = Factory.create( :post )
	end
 
 	it "should be valid" do
		@post.should be_valid
	end

	it "should be invalid without a title" do
		@post.title = ''
		@post.should be_invalid
	end

	it "should be invalid without a body" do
		@post.body = ''
		@post.should be_invalid
	end

	it "should be invalid without a user" do
		@post.user = nil
		@post.should be_invalid
	end

	it "should generate a valid slug after save" do
		@post = Factory.create( :post, :title => "A very cool - first post!" )
		@post.slug.should match( /^a-very-cool-first-post$/ )
	end

	it "should generate a valid url after save" do
		@post = Factory.create( :post, :title => "A very cool - first post!" )
		@post.created_at = '2010/02/08'
		@post.url.should match( /^\/2010\/02\/08\/a-very-cool-first-post$/ )
	end

end
