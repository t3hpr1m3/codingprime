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

class Comment < ActiveRecord::Base
  belongs_to :post
  has_rakismet :author => :user_name,
                :author_email => :user_email,
                :author_url => :user_site,
                :comment_type => 'comment',
                :content => :comment_text,
                :permalink => proc { post.url }

  before_save   :check_spam, :only => :create

  validates_presence_of :user_name, :user_email, :comment_text, :user_ip, :user_agent, :post
  attr_accessible :user_name, :user_site, :user_email, :comment_text

  def request=( request )
    self.user_ip = request.remote_ip
	self.user_agent = request.env['HTTP_USER_AGENT']
	self.referrer = request.env['HTTP_REFERER']
  end

  def check_spam
    self.approved = !spam?
    true
  end

  def approve
    self.ham!
    self.approved = true
  end

  def reject
    self.spam!
    self.approved = false
  end

  def self.approved
    find( :all, :conditions => 'approved=1', :order => 'created_at DESC' )
  end

  def self.recent( limit, criteria = nil )
    find( :all, :limit => limit, :conditions => criteria, :order => 'created_at DESC' )
  end
end
