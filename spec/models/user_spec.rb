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

require 'spec_helper'

describe User do
  let!(:user) { create(:user, password: 'valid', password_confirmation: 'valid') }

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_uniqueness_of(:email) }

  it 'should authenticate with a valid password' do
    expect(user.authenticate('valid')).to eql(user)
  end

  it 'should fail authentication with an invalid password' do
    expect(user.authenticate('invalid')).to be false
  end
end
