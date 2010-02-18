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
end
