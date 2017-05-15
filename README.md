# Converter Money
[![Gem Version](https://badge.fury.io/rb/converter-money.svg)](https://badge.fury.io/rb/converter-money)

Converter Money is a Ruby gem that performs currency conversion and arithmetics with different currencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'converter-money'
```

And then execute:
```sh
$ bundle install
```
Or install it yourself as:
```sh
$ gem install converter-money
```
## Usage

__Configure the converstion rates__

```ruby
Converter::Money.conversion_rates('EUR', {
  'USD' => 1.11,
  'Bitcoin' => 0.0047
})
```
__Create an instance of Converter::Money__

```ruby
fifty_eur = Convrter::Money.new(50, 'EUR')

fifty_eur.amount   # => 50
fifty_eur.currency # => "EUR"
fifty_eur.inspect  # => "50.00 EUR"
```

### Converting to a different currency
Note that the currency must be available in the configuration. `ConverterMoney#convert_to` returns an instance of `ConverterMoney`.

```ruby
fifty_eur.convert_to('USD')     # => 55.50 USD
fifty_eur.convert_to('Bitcoin') # => 0.24 Bitcoin

twenty_usd = Converter::Money.new(20, 'USD')
twenty_usd.convert_to('EUR')    # => 18.02 EUR
```

### Performing operations in different currencies

### Arithmetics:

```ruby
fifty_eur + twenty_dollars # => 68.02 EUR
fifty_eur - twenty_dollars # => 31.98 EUR
fifty_eur / 2              # => 25 EUR
twenty_dollars * 3         # => 60 USD
```

### Comparisons:

Note that two monetary values are considered to be equal if they are the same up to 2 decimal places

```ruby
twenty_dollars == Money.new(20, 'USD') # => true
twenty_dollars == Money.new(30, 'USD') # => false

fifty_eur_in_usd = fifty_eur.convert_to('USD')
fifty_eur_in_usd == fifty_eur          # => true

twenty_dollars > Money.new(5, 'USD')   # => true
twenty_dollars < fifty_eur             # => true
```

## Support

- Any bugs about Converter::Money, please feel free to report [here](https://github.com/segun-adeleye/converter-money).
- Contributions are also welcome. Just fork and send pull requests.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
