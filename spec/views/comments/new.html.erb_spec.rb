require 'spec_helper'

describe "/comments/new.html.erb" do
  include CommentsHelper

  before(:each) do
    assigns[:comment] = stub_model(Comment,
      :new_record? => true,
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

  it "renders new comment form" do
    render

    response.should have_tag("form[action=?][method=post]", comments_path) do
      with_tag("input#comment_user_name[name=?]", "comment[user_name]")
      with_tag("input#comment_user_site[name=?]", "comment[user_site]")
      with_tag("input#comment_user_email[name=?]", "comment[user_email]")
      with_tag("textarea#comment_comment_text[name=?]", "comment[comment_text]")
      with_tag("input#comment_user_ip[name=?]", "comment[user_ip]")
      with_tag("input#comment_user_agent[name=?]", "comment[user_agent]")
      with_tag("input#comment_referrer[name=?]", "comment[referrer]")
      with_tag("input#comment_post[name=?]", "comment[post]")
      with_tag("input#comment_approved[name=?]", "comment[approved]")
    end
  end
end
