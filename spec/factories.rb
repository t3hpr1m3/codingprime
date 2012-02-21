FactoryGirl.define do
  sequence :username do |n|
    "user#{n}"
  end

  sequence :name do |n|
    "Test User#{n}"
  end

  sequence :email do |n|
    "foo#{n}@bar.com"
  end

  sequence :blog_title do |n|
    "Test Post #{n}"
  end

  sequence :category_name do |n|
    "Test Category #{n}"
  end

  factory :user do
    username { Factory.next( :username ) }
    password "foobar"
    password_confirmation { |u| u.password }
    email { Factory.next( :email ) }
    name { Factory.next( :name ) }
    is_admin false
  end

  factory :admin, :class => User do
    username { Factory.next( :username ) }
    password "foobar"
    password_confirmation { |f| f.password }
    email { Factory.next( :email ) }
    name { Factory.next( :name ) }
    is_admin true
  end

  factory :category do
    name { Factory.next(:category_name) }
    slug { Category.generate_slug(name) }
  end

  factory :post do
    title { Factory.next( :blog_title ) }
    body "This is some test text"
    association :user
    association :category
  end

  factory :comment do
    author_name "comment_user"
    author_site "www.google.com"
    author_email "testuser@foo.com"
    comment_text "My test comment"
    author_ip "127.0.0.1"
    author_user_agent "Mozilla"
    referrer ""
    approved false
    association :post
  end
end
