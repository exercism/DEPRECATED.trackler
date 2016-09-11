# Trackler

The data for the exercises in for all of the Exercism language tracks, along with the code to sew it all together.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trackler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trackler

## Usage

To access a language track, use the track id (e.g. `ruby`, `cpp`):

```
track = Trackler.tracks["fsharp"]
track.language
# => "F#"
```

Tracks have implementations of specific problems:

```
track.implementations.each do |implementation|
  # implementation.files, implementation.readme, etc
end
```

To get a problem, use the problem slug:

```
problem = Trackler.problems["leap"]
```

Problems contain the generic, language-independent metadata:

```
problem.blurb
# => "Write a program that will take a year and report if it is a leap year."
problem.name
# => "Leap"
```

You can get all of the different language implementations for a problem:

```

Trackler.implementations[problem.slug].each do |implementation|
  # ...
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/exercism/trackler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

See CONTRIBUTING.md for details.

This is an extraction from https://github.com/exercism/x-api.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
