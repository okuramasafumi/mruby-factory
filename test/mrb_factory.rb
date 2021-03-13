##
## Factory Test
##

class User
  attr_accessor :id, :name, :admin, :full_name, :email, :posts
end

class Post
  attr_accessor :user_id, :body
end

Factory.define do
  sequence(:email) {|i| "email#{i}@example.com" }

  factory :user do
    sequence(:id, 1) {|i| i }
    name { 'name' }
    admin { false }

    trait :admin do
      admin { true }
    end

    factory :user_with_full_name do
      full_name { 'John Doe' }
    end
  end

  factory :post do
    sequence(:body) {|i| "Body:#{i}"}
  end

  factory :user_with_some_posts, class_name: 'User' do
    after_create do |user|
      user.posts = 3.times.map { Factory.create(:post, user_id: user.id) }
    end
  end
end

assert('user factory') do
  user = Factory.create :user
  assert_equal 'name', user.name
  assert_equal false, user.admin
end

assert('user factory with traits and params') do
  user = Factory.create :user, :admin, name: 'arg'
  assert_equal 'arg', user.name
  assert_equal true, user.admin
end

assert('nested factory') do
  user_with_full_name = Factory.create :user_with_full_name
  assert_equal 'John Doe', user_with_full_name.full_name
end

assert('global sequence') do
  assert_equal 'email0@example.com', Factory.generate(:email)
  assert_equal 'email1@example.com', Factory.generate(:email)
end

assert('factory with callback') do
  user_with_some_posts = Factory.create :user_with_some_posts
  assert_equal 3, user_with_some_posts.posts.size
end
