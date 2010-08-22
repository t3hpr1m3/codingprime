require 'slug_extensions'

Factory.sequence :username do |n|
  "user#{n}"
end

Factory.sequence :name do |n|
  "Test User#{n}"
end

Factory.sequence :email do |n|
  "foo#{n}@bar.com"
end

Factory.sequence :blog_title do |n|
  "Test Post #{n}"
end

Factory.sequence :category_name do |n|
  "Test Category #{n}"
end

Factory.define :user do |f|
  f.username { Factory.next( :username ) }
  f.password "foobar"
  f.password_confirmation { |u| u.password }
  f.email { Factory.next( :email ) }
  f.name { Factory.next( :name ) }
  f.is_admin false
end

Factory.define :admin, :class => User do |u|
  u.username { Factory.next( :username ) }
  u.password "foobar"
  u.password_confirmation { |f| f.password }
  u.email { Factory.next( :email ) }
  u.name { Factory.next( :name ) }
  u.is_admin true
end

Factory.define :category do |c|
  c.name { Factory.next( :category_name ) }
  c.slug { |s| Category.generate_slug( s.name ) }
end

Factory.define :post do |p|
  p.title { Factory.next( :blog_title ) }
  p.body "This is some test text"
  p.association :user
  p.association :category
end

Factory.define :comment do |c|
  c.author_name "comment_user"
  c.author_site "www.google.com"
  c.author_email "testuser@foo.com"
  c.comment_text "My test comment"
  c.author_ip "127.0.0.1"
  c.author_user_agent "Mozilla"
  c.referrer ""
  c.approved false
  c.association :post
end
