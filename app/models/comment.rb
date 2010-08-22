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
  include Rakismet::Model
  belongs_to :post
  rakismet_attrs :author => :author_name,
                :author_url => :author_site,
                :comment_type => 'comment',
                :content => :comment_text,
                :permalink => proc { post.url },
                :user_ip => :author_ip,
                :user_agent => :author_user_agent

  before_save   :check_spam, :only => :create
  before_save   :add_protocol_to_author_site

  validates_presence_of :author_name, :author_email, :comment_text, :author_ip, :author_user_agent, :post
  attr_accessible :author_name, :author_site, :author_email, :comment_text
  named_scope :valid, :conditions => { :approved => true }, :order => 'created_at ASC'
  named_scope :rejected, :conditions => { :approved => false }, :order => 'created_at ASC'

  def request=( request )
    self.author_ip = request.remote_ip
	self.author_user_agent = request.env['HTTP_USER_AGENT']
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

  def add_protocol_to_author_site
    self.author_site = "http://#{author_site}" unless author_site.blank? || author_site.include?( "://" )
  end
end
