# == Schema Information
# Schema version: 20100226030058
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Category do
  before( :each ) do
    Factory.create( :category )
  end

  it { should validate_presence_of( :name ) }
  it { should validate_uniqueness_of( :name ) }

  it "should generate a valid slug on save" do
    @category = Factory.build( :category, :name => 'Test Category', :slug => nil )
    @category.save!
    @category.slug.should match( /^test-category$/ )
  end
end
