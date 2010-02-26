# == Schema Information
# Schema version: 20100226030058
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
  before( :each ) do
    Factory( :comment )
  end

  it { should validate_presence_of( :comment_text ) }
  it { should validate_presence_of( :user_name ) }
  it { should validate_presence_of( :user_email ) }
  it { should validate_presence_of( :user_ip ) }
  it { should validate_presence_of( :user_agent ) }
  it { should belong_to( :post ) }

  it "should be approved it it's not spam" do
    @comment = Factory.build( :comment )
    @comment.should be_valid
    @comment.should_receive( :spam? ).and_return( false )
    @comment.save!
    @comment.approved.should eql( true )
  end

  it "should be rejected if it's spam" do
    @comment = Factory.build( :comment )
    @comment.should be_valid
    @comment.should_receive( :spam? ).and_return( true )
    @comment.save!
    @comment.approved.should eql( false )
  end

  it "should be marked as ham if it's approved" do
    @comment = Factory.build( :comment )
    @comment.should be_valid
    @comment.should_receive( :ham! )
    @comment.approve
    @comment.approved.should eql( true )
  end

  it "should be marked as spam if it's rejected" do
    @comment = Factory.build( :comment )
    @comment.should be_valid
    @comment.should_receive( :spam! )
    @comment.reject
    @comment.approved.should eql( false )
  end
end
