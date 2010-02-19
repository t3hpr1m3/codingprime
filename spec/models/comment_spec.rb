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
end
