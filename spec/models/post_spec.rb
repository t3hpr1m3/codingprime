# == Schema Information
# Schema version: 20100211191224
#
# Table name: posts
#
#	id				 :integer				 not null, primary key
#	title			:string(255)
#	body			 :text
#	slug			 :string(255)
#	created_at :datetime
#	updated_at :datetime
#

require 'spec_helper'

describe Post do
	before(:each) do
		@valid_attributes = {
			:title => "Test Post",
			:body => "Some interesting text.",
			:slug => "test-post"
		}
		@post = Post.new( @valid_attributes )
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

	it "should generate a valid slug" do
		@post.title = 'It\'s a pretty - cool first post!'
		Post.create_slug( @post.title ).should match( /^its-a-pretty-cool-first-post$/ )
	end

	it "should generate a valid url" do
		@post.created_at = '2010/02/08'
		@post.url.should match( /^\/2010\/02\/08\/test-post$/ )
	end

end
