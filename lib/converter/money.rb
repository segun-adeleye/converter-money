require "converter/money/version"

module Converter
  class Money
    class << self
      attr_reader :base_currency, :other_currencies
    end

    attr_reader :amount, :currency

    def self.conversion_rates(base_currency, other_currencies)
      @base_currency = base_currency
      @other_currencies = other_currencies
    end

    def initialize(amount, currency)
      @amount = amount
      @currency = currency
    end

    def inspect
      "#{formatted_amount} #{currency}"
    end

    def convert_to(new_currency)
      currency == new_currency ? self : Money.new(amount * Money.other_currencies[new_currency], new_currency)
    end

  private

    def formatted_amount
      "%.2f" % amount.round(2)
    end
  end
end
