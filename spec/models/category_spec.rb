# == Schema Information
# Schema version: 20100816142128
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
  before do
    Factory(:category)
  end

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it "should generate a valid slug on save" do
    category = Factory.build(:category, name: 'Test Category', slug: nil )
    category.save!
    category.slug.should match( /^test-category$/ )
  end

  it 'should not allow destroy if it has posts' do
    category = Factory(:category)
    post = Factory(:post, category: category)
    category.destroy.should be_false
  end
end
