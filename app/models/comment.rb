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

class Comment < ActiveRecord::Base
  belongs_to :post
  validates_presence_of :user_name, :user_email, :comment_text, :user_ip, :user_agent, :post
  attr_accessible :user_name, :user_site, :user_email, :comment_text

  def self.approved
    find( :all, :conditions => 'approved=1', :order => 'created_at DESC' )
  end

  def self.recent( limit, criteria = nil )
    find( :all, :limit => limit, :conditions => criteria, :order => 'created_at DESC' )
  end
end
