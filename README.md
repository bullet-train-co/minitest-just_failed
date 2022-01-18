# Minitest::JustFailed

`Minitest::JustFailed` is an extension of the `TestUnitReporter` used in Rails, allowing you to rerun the tests that failed most recently with commands like `$ rails test:failed`.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'minitest-just_failed'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install minitest-just_failed

## Usage

The tests that failed most recently are logged automatically, so running one of the following commands will rerun these tests only depending on your use-case:
```
$ rails test:failed
$ rails test:system:failed
$ rails test:all:failed
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Since we run rake test tasks inside our tests, we test this gem inside of a dummy Rails application.
Add any tests necessary within `test/just_failed_test.rb` and run the following command within the `test/dummy_app` directory:
```
$ bundle exec rails test test/just_failed_test.rb
```

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bullet-train-co/minitest-just_failed.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bullet-train-co/minitest-just_failed/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Minitest::JustFailed project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bullet-train-co/minitest-just_failed/blob/master/CODE_OF_CONDUCT.md).
