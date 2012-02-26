# == Schema Information
# Schema version: 20100816142128
#
# Table name: comments
#
#  id                :integer         not null, primary key
#  author_name       :string(255)
#  author_site       :string(255)
#  author_email      :string(255)
#  comment_text      :text
#  author_ip         :string(255)
#  author_user_agent :string(255)
#  referrer          :string(255)
#  post_id           :integer
#  approved          :boolean
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Comment do

  it { should validate_presence_of(:comment_text) }
  it { should validate_presence_of(:author_name) }
  it { should validate_presence_of(:author_email) }
  it { should validate_presence_of(:author_ip) }
  it { should validate_presence_of(:author_user_agent) }
  it { should belong_to(:post) }

  let(:comment) { Factory.build(:comment) }

  it "should be approved if it's not spam" do
    register_akismet_uri 'comment-check', 'false'
    comment.save!
    comment.approved.should eql(true)
  end

  it "should be rejected if it's spam" do
    register_akismet_uri 'comment-check', 'true'
    comment.save!
    comment.approved.should eql(false)
  end

  it "should be marked as ham if it's approved" do
    register_akismet_uri 'submit-ham', 'true'
    comment.approve
    comment.approved.should eql(true)
  end

  it "should be marked as spam if it's rejected" do
    register_akismet_uri 'submit-spam', 'true'
    comment.reject
    comment.approved.should eql(false)
  end

  describe 'assigning the request' do
    let(:request) { stub(remote_ip: '127.0.0.1', env: {'HTTP_USER_AGENT' => 'browser', 'HTTP_REFERER' => 'www.google.com'}) }
    before do
      comment.request = request
    end
    specify { comment.author_ip.should eql('127.0.0.1') }
    specify { comment.author_user_agent.should eql('browser') }
    specify { comment.referrer.should eql('www.google.com') }
  end

  def register_akismet_uri(path, response_text)
    FakeWeb.register_uri :post, /.*rest.akismet.com\/1.1\/#{path}/, body: response_text
  end
end
