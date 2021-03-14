[![CI](https://github.com/okuramasafumi/mruby-factory/actions/workflows/main.yml/badge.svg)](https://github.com/okuramasafumi/mruby-factory/actions/workflows/main.yml)

# mruby-factory

Factory implementation for mruby.

## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'okuramasafumi/mruby-factory'
end
```

## Usage

The basic usage of `mruby-factory` is similar to [FactoryBot](https://github.com/thoughtbot/factory_bot), but there are some important differences.

### Defining and creating factories

You can define factories with `Factory.define` and `factory` method.

After defining the factory, you can create an object from it using `Factory.create`.

```ruby
class User
  attr_accessor :username
end

Factory.define do
  factory :user do
    username { 'factory' }
  end
end

user = Factory.create :user
user.username # => 'factory'
```

### Specifying class name

`Factory` tries to get class name from the name of the factory, but it fails when it contains `_` or `/`. In these cases, you must specify class name with `class_name` option.

```ruby
class FooBar
  attr_accessor :baz
end

Factory.define do
  factory :foo_bar, class_name: 'FooBar' do
    baz { 'the baz' }
  end
end

foo_bar = Factory.create :foobar
foo_bar.baz # => 'the baz'
```

### Grouping attributes with traits

With traits, you can group and name the attributes and apply it when creating the object.

```ruby
class User
  attr_accessor :username, :admin
end

Factory.define do
  factory :user do
    username { 'factory' }
    admin { false }
  end

  trait :admin do
    admin { true }
  end
end

admin_user = Factory.create :user, :admin
admin_user.admin # => true
non_admin_user = Factory.create :user
non_admin_user.admin # => false
```

### Nested factories

Factories can be nested, so we can define "admin" with nested  factories, not trait.

```ruby
class User
  attr_accessor :username, :admin
end

Factory.define do
  factory :user do
    username { 'factory' }
    admin { false }

    factory :admin do
      admin { true }
    end
  end
end

admin_user = Factory.create :admin
admin_user.admin # => true
non_admin_user = Factory.create :user
non_admin_user.admin # => false
```

### Sequence

You can use two types of sequence: global sequence and attribute sequence.

#### Global sequence

You can define sequence globally in `define` block.

```ruby
Factory.define do
  sequence(:number) {|i| i}
end

Factory.generate :number # => 0
Factory.generate :number # => 1
```

You can decide the initial number.

```ruby
Factory.define do
  sequence(:id, 1) {|i| i}
end

Factory.generate :id # => 1
Factory.generate :id # => 2
```

#### Attribute sequence

You can make attribute unique with sequence.

```ruby
class User
  attr_accessor :username, :email
end

Factory.define do
  factory :user do
    username { 'factory' }
    sequence(:email) {|i| "email#{i}@example.com" }
  end
end

user1 = Factory.create :user
user1.email # => "email0@example"
user2 = Factory.create :user
user2.email # => "email1@example"
```

You can also decide the initial number for the sequence as global sequence.

### Callback

You can define a callback which is executed after `create`.

```ruby
class User
  attr_accessor :username, :posts
end

class Post
  attr_accessor :user_id, :body
end

Factory.define do
  factory :post do
    body { 'body' }
  end
  factory :user do
    username { 'factory' }

    factory :user_with_posts do
      after_create do |user|
        user.posts = 3.times.map { Factory.create(:post, user_id: user.id) }
      end
    end
  end
end

user1 = Factory.create :user
user1.posts # => nil
user2 = Factory.create :user_with_posts
user2.posts # => 3 posts
```

## License
under the MIT License:
- see LICENSE file
