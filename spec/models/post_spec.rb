# == Schema Information
# Schema version: 20100816142128
#
# Table name: posts
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  body        :text
#  slug        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  category_id :integer
#

require 'spec_helper'

describe Post do

  it { should validate_presence_of( :title ) }
  it { should validate_presence_of( :body ) }
  it { should belong_to( :user ) }

  it "should generate a valid slug after save" do
    @post = build( :post, :title => "A very cool - first post!" )
    @post.save!
    expect(@post.slug).to match( /^a-very-cool-first-post$/ )
  end

  it "should generate a valid url after save" do
    @post = create( :post, :title => "A very cool - first post!" )
    @post.created_at = '2010/02/08'
    expect(@post.url).to match( /^\/2010\/02\/08\/a-very-cool-first-post$/ )
  end

end

