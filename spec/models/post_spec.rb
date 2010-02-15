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

require 'spec_helper'

describe Post do
	before(:each) do
		@valid_attributes = {
			:title => "A very cool - first post!",
			:body => "Some *interesting* text."
		}
		@post = Post.new( @valid_attributes )
		ActiveRecord.stub!(:create).and_return(nil)
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

	it "should generate a valid slug on save" do
		@post.save
		@post.slug.should match( /^a-very-cool-first-post$/ )
	end

	it "should render a valid body on save" do
		@post.save
		@post.rendered_body.chomp.should eql( '<p>Some <em>interesting</em> text.</p>' )
	end

	it "should generate a valid url after save" do
		@post.created_at = '2010/02/08'
		@post.save
		@post.url.should match( /^\/2010\/02\/08\/a-very-cool-first-post$/ )
	end

end
