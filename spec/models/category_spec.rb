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
    build(:category)
  end

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it "should generate a valid slug on save" do
    category = build(:category, name: 'Test Category', slug: nil )
    category.save!
    expect(category.slug).to match( /^test-category$/ )
  end

  it 'should not allow destroy if it has posts' do
    category = create(:category)
    post = create(:post, category: category)
    expect(category.destroy).to be false
  end
end
