# == Schema Information
# Schema version: 20100218212613
#
# Table name: comments
#
#  id           :integer         not null, primary key
#  user_name    :string(255)
#  user_site    :string(255)
#  user_email   :string(255)
#  comment_text :text
#  user_ip      :string(255)
#  user_agent   :string(255)
#  referrer     :string(255)
#  post_id      :integer
#  approved     :boolean
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Comment do
  before(:each) do
    @comment = Factory.build( :comment )
  end

  it "should be valid" do
    @comment.should be_valid
  end

  it "should save" do
    @comment.save!
  end

  it "should be invalid without text" do
    @comment.comment_text = ""
    @comment.should be_invalid
  end

  it "should be invalid without a user_name" do
    @comment.user_name = ""
    @comment.should be_invalid
  end

  it "should be invalid without an email address" do
    @comment.user_email = ""
    @comment.should be_invalid
  end

  it "should be invalid without an IP" do
    @comment.user_ip = ""
    @comment.should be_invalid
  end

  it "should be invalid without a user_agent" do
    @comment.user_agent = ""
    @comment.should be_invalid
  end

  it "should be invalid without a post" do
    @comment.post = nil
    @comment.should be_invalid
  end

  it "should be approved it it's not spam" do
    @comment.should_receive( :spam? ).and_return( false )
    @comment.save
    @comment.approved.should eql( true )
  end

  it "should be rejected if it's spam" do
    @comment.should_receive( :spam? ).and_return( true )
    @comment.save
    @comment.approved.should eql( false )
  end

  it "should be marked as ham if it's approved" do
    @comment.should_receive( :ham! )
    @comment.approve
    @comment.approved.should eql( true )
  end

  it "should be marked as spam if it's rejected" do
    @comment.should_receive( :spam! )
    @comment.reject
    @comment.approved.should eql( false )
  end
end
