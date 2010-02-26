require 'spec_helper'

describe "/categories/index.html.erb" do
  include CategoriesHelper

  before(:each) do
    assigns[:categories] = [
      stub_model(Category,
        :name => "value for name",
        :slug => "value for slug"
      ),
      stub_model(Category,
        :name => "value for name",
        :slug => "value for slug"
      )
    ]
  end

  it "renders a list of categories" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for slug".to_s, 2)
  end
end
