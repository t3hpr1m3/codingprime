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
#
#  id            :integer         not null, primary key
#  title         :string(255)
#  body          :text
#  rendered_body :text
#  slug          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
