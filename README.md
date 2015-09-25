# EmberRoutes

This gem makes integration testing Rails-backed Ember apps a little easier.

Given a Rails project with an embedded Ember app, whether using [ember-cli-rails](https://github.com/rwz/ember-cli-rails) or otherwise, you will likely want to run integration tests using Capybara.  

Unfortunately, Ember's route definitions are tucked away in a router.js file, and are not available to the Ruby spec code.

EmberRoutes tries to address this by allowing you to express your Ember routes using a similar syntax, then generating corresponding path helpers and placing them within a PathHelpers module.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ember-routes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ember-routes

## Usage

To define your Ember application routes, call `EmberRoutes.configure` like so:

```
EmberRoutes.configure do |config|
  config.prefix = prefix # A string to prefix the path helper names.  Defaults to ''
  config.base_url = base_url # The base url for the application, it will prefix the paths. Defaults to ''
  config.routes do
    route 'foo', :path => '/foo' do
      route 'bar', :path => '/bar' do
        route 'show', :path => '/:id'
      end
    end
  end
end
```

If you're using Rails, the above configuration can be placed in it's own initializer such as `config/initializers/ember_routes.rb` or in the rails_helper file.

Running the configuration will generate the path helpers and place them within the EmberRails::PathHelpers module.  You can them include them like so:

```
#spec/spec_helper

include EmberRails::PathHelpers

```

The above configuration will generate the following path helpers:

```
foo_path #/foo
foo_bar_path #/foo/bar
foo_bar_show_path #/foo/bar/:id
```

Note that paths that include parameters (defined using the colon notation) will insert the parameters into
the path itself.  For example, given the above configuration:

```
foo_bar_show_path(:id => 12, :sort => 'ASC')
#=> /foo/bar/12?sort=ASC
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asseltine/ember-routes


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
