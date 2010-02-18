require 'spec_helper'

describe "/comments/index.html.erb" do
  include CommentsHelper

  before(:each) do
    assigns[:comments] = [
      stub_model(Comment,
        :user_name => "value for user_name",
        :user_site => "value for user_site",
        :user_email => "value for user_email",
        :comment_text => "value for comment_text",
        :user_ip => "value for user_ip",
        :user_agent => "value for user_agent",
        :referrer => "value for referrer",
        :post => 1,
        :approved => false
      ),
      stub_model(Comment,
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
    ]
  end

  it "renders a list of comments" do
    render
    response.should have_tag("tr>td", "value for user_name".to_s, 2)
    response.should have_tag("tr>td", "value for user_site".to_s, 2)
    response.should have_tag("tr>td", "value for user_email".to_s, 2)
    response.should have_tag("tr>td", "value for comment_text".to_s, 2)
    response.should have_tag("tr>td", "value for user_ip".to_s, 2)
    response.should have_tag("tr>td", "value for user_agent".to_s, 2)
    response.should have_tag("tr>td", "value for referrer".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
  end
end
