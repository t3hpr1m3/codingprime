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
