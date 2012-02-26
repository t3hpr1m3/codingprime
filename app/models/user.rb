# == Schema Information
# Schema version: 20100816142128
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

require 'digest/sha1'

class User < ActiveRecord::Base
  has_secure_password

  has_many :posts
  attr_accessible         :name, :email, :is_admin
  validates_presence_of   :username, :email
  validates_presence_of   :password, :on => :create
  validates_uniqueness_of :username, :email
end
