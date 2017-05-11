require "converter/money/version"

module Converter
  class Money
    class << self
      attr_reader :base_currency, :other_currencies
    end

    def self.conversion_rates(base_currency, other_currencies)
      @base_currency = base_currency
      @other_currencies = other_currencies
    end
  end
end
