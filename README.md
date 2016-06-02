# Differ

The goal of this task is to develop Ruby application that can compare the content of two files.
http://www.diffnow.com/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'differ'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install differ

## Usage

### From terminal

    $ ./bin/differ -f ./spec/factories/files/file1.txt -f ./spec/factories/files/file2.txt

http://take.ms/wVRSl

### Code version

```ruby
broker = Differ::Broker.new(string1, string2, formatter: Differ::Formatters::Text)
broker.compare
puts broker.comparison
```

## Tests

    $ bundle exec rspec ./spec

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/galetahub/differ.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

