require 'spec_helper'

describe "/comments/show.html.erb" do
  include CommentsHelper
  before(:each) do
    assigns[:comment] = @comment = stub_model(Comment,
      :user_name => "value for user_name",
      :user_site => "value for user_site",
      :user_email => "value for user_email",
      :comment_text => "value for comment_text",
      :user_ip => "value for user_ip",
      :user_agent => "value for user_agent",
      :referrer => "value for referrer",
      :post => 1,
      :approved => false
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ user_name/)
    response.should have_text(/value\ for\ user_site/)
    response.should have_text(/value\ for\ user_email/)
    response.should have_text(/value\ for\ comment_text/)
    response.should have_text(/value\ for\ user_ip/)
    response.should have_text(/value\ for\ user_agent/)
    response.should have_text(/value\ for\ referrer/)
    response.should have_text(/1/)
    response.should have_text(/false/)
  end
end
