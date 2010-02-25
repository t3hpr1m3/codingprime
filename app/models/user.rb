# == Schema Information
# Schema version: 20100218212613
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
  has_many :posts
  attr_accessor       :password
  attr_accessible       :name, :email, :is_admin, :password
  validates_presence_of   :username, :password, :email
  validates_uniqueness_of :username, :email
  validates_confirmation_of :password
  before_save         :encrypt_password

  def self.authenticate( username, password )
    u = find( :first, :conditions => ["username = ?", username] )
    return nil if u.nil?
    return u if User.encrypt( password, u.salt ) == u.encrypted_password
    nil
  end

  private

  def encrypt_password
    self.salt = User.random_string( 20 ) if !self.salt?
    self.encrypted_password = User.encrypt( self.password, self.salt )
  end

  def self.encrypt( str, salt )
    Digest::SHA1.hexdigest( str + salt )
  end

  def self.random_string( len )
    # generate a random password consisting of strings and digits
    chars = ( "a".."z" ).to_a + ( "A".."Z" ).to_a + ( "0".."9" ).to_a
    newpass = ""
    1.upto( len ) { |i| newpass << chars[rand( chars.size - 1 )] }
    return newpass
  end
end
