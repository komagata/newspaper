# Newspaper

Newspaper is a small library that provides a pub/sub mechanism for ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'newspaper'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install newspaper

## Usage

It can be used as an alternative to ActiveRecord Callbacks and Observers. Subscribers are just Ruby objects, so they are easy to implement and test.

Callbacks and Observers have the following problems

- There are often times when you don't want a Callback to be called. We don't want that to happen implicitly.
- Easy to write multiple processes in one place. Easy to have dependencies on multiple processes.

Newspaper solves the above problem by

- Events are explicitly published.
- Subscriber is easy to write as a class for each process

Using ActiveRecord callbacks.

```ruby
class User
  after_create UserCallbacks.new
end

class UserCallbacks
  def after_save(user)
    # do something
  end
end

@user.save
```

If Newspaper is used, it can be written as follows.

```ruby
# app/models/sign_up_notifier.rb
class SignUpNotifier
  def call(payload)
    # do something
  end
end

# config/initializers/newspaper.rb
Rails.configuration.after_initialize do
  Newspaper.subscribe(:user_create, SignUpNotifier.new)
end

# app/controllers/users_controller.rb
Newspaper.publish(:user_create, payload)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test-unit` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/komagata/newspaper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/komagata/newspaper/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Newspaper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/komagata/newspaper/blob/main/CODE_OF_CONDUCT.md).
