# Spaux

This is yet another Ruby gem to automate some Chef and cloud computing tasks.

I was not satisfied with some programmatic features from Opscode code so I went ahead and wrote my own gem.

What I'm aiming for is to centralize credentials (API, SSL keys, etc) in the Chef server (e.g. encrypted data bags or chef-vault), store cloud providers settings there as well (plain data bags and attributes) and have a very very simple CLI to launch new environments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spaux'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spaux

## Usage

TODO: Write usage instructions here. Open an issue with questions if you are insterested, I'm still organizing this.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/spaux/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
