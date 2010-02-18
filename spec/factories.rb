Factory.define :user do |u|
	u.sequence(:username) { |n| "user#{n}" }
	u.password "foobar"
	u.password_confirmation { |f| f.password }
	u.sequence(:email) { |n| "foo#{n}@bar.com" }
	u.name "Test User"
	u.is_admin false
end

Factory.define :admin, :class => User do |u|
	u.username "admin"
	u.password "foobar"
	u.password_confirmation { |f| f.password }
	u.email "fooadmin@bar.com"
	u.name "Test User"
	u.is_admin true
end

Factory.define :post do |p|
	p.sequence(:title) { |n| "Test Post #{n} " }
	p.body "This is some test text"
	p.association :user
end

Factory.define :new_post, :class => Post do |p|
	p.sequence(:title) { |n| "Test Post #{n} " }
	p.body "This is some test text"
	p.user nil
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
