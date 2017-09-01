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

To get the specification of a problem, use the exercise slug:

```
specification = Trackler.specifications["leap"]
```

Specifications contain the generic, language-independent metadata:

```
specification.blurb
# => "Write a program that will take a year and report if it is a leap year."
specification.name
# => "Leap"
```

You can get all of the different language implementations for a specification:

```

Trackler.implementations[specification.slug].each do |implementation|
  # ...
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Adding a new language track

Language tracks are included as submodules. To add a new one, run the following command, defining the track id as an environment variable. Shown here with `prolog` as an example.

```
$ TRACK_ID=prolog; git submodule add https://github.com/exercism/$TRACK_ID tracks/$TRACK_ID
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/exercism/trackler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

See CONTRIBUTING.md for details.

This is an extraction from https://github.com/exercism/x-api.

## Publishing

Owners of the gem can publish it to rubygems like this:

```
gem build trackler.gemspec
gem install --local trackler-$VERSION.gem
gem push trackler-$VERSION.gem
```
## Users

Projects that make use of this gem:

* https://github.com/exercism/exercism.io
* https://github.com/exercism/x-api
* https://github.com/sandimetz/99bottles-polyglot

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
