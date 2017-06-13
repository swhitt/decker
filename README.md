# Decker

[![Build Status](https://travis-ci.org/swhitt/decker.svg?branch=develop)](https://travis-ci.org/swhitt/decker)

Decker is a representation of a [Standard 52-card deck](https://en.wikipedia.org/wiki/Standard_52-card_deck) with a simple parser and hand evaluator for [Project Euler's](https://projecteuler.net) [Problem 54](https://projecteuler.net/problem=54).

To experiment with the code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install decker

## Usage

Create two hands:

```ruby
hand = Decker::Hand.new

hand << Decker::Card.new('TH')
hand << Decker::Card.new('TD')
hand << Decker::Card.new('TC')
hand << Decker::Card.new('5S')
hand << Decker::Card.new('7C')

hand2 = Decker::Hand.new('3C 3D 3S 9S 9D')
```

Compare / sort them using standard Ruby :


```ruby
hand <=> hand2
# => 1
```

You can run the code against a Project Euler [`poker.txt`](https://projecteuler.net/project/resources/p054_poker.txt)-style input using the command line tool provided:

```
$ bundle exec decker 
```
This will automatically grab `poker.txt` from the Project Euler website, parse the card notation, score
the hands and output the result score.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/swhitt/decker.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
