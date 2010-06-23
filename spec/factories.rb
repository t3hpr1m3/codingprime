Factory.sequence :username do |n|
  "user#{n}"
end

Factory.sequence :email do |n|
  "foo#{n}@bar.com"
end

Factory.sequence :blog_title do |n|
  "Test Post #{n}"
end

Factory.sequence :category_name do |n|
  "Text Category #{n}"
end

Factory.define :user do |f|
  f.username { Factory.next( :username ) }
  f.password "foobar"
  f.password_confirmation { |u| u.password }
  f.email { Factory.next( :email ) }
  f.name "Test User"
  f.is_admin false
end

Factory.define :admin, :class => User do |u|
  u.username { Factory.next( :username ) }
  u.password "foobar"
  u.password_confirmation { |f| f.password }
  u.email { Factory.next( :email ) }
  u.name "Test User"
  u.is_admin true
end

Factory.define :category do |c|
  c.name { Factory.next( :category_name ) }
  c.slug "test-category"
end

Factory.define :post do |p|
  p.title { Factory.next( :blog_title ) }
  p.body "This is some test text"
  p.association :user
  p.association :category
end

Factory.define :comment do |c|
  c.user_name "comment_user"
  c.user_site "www.google.com"
  c.user_email "testuser@foo.com"
  c.comment_text "My test comment"
  c.user_ip "127.0.0.1"
  c.user_agent "Mozilla"
  c.referrer ""
  c.approved false
  c.association :post
end
