# == Schema Information
# Schema version: 20100215170027
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  username           :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  name               :string(255)
#  email              :string(255)
#  is_admin           :boolean
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe User do
	before(:each) do
		@user = Factory.create( :user )
		User.stub( :find ).and_return( @user )
	end

	it "should create a new instance given valid attributes" do
		@user.should be_valid
	end

	it "should be invalid without a username" do
		@user.username = nil
		@user.should be_invalid
	end

	it "should be invalid without an email address" do
		@user.email = nil
		@user.should be_invalid
	end

	it "should be invalid without a password" do
		@user.password = nil
		@user.should be_invalid
	end

	it "should authenticate with a valid password" do
		User.authenticate( "testuser", "foobar" ).should eql( @user )
	end

	it "should fail authentication with an invalid password" do
		User.authenticate( "testuser", "invalid" ).should be_nil
	end
end
