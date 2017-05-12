module Converter
  module Validator

  private
    def validate(amount, currency)
      validate_amount(amount)
      validate_currency(currency)
    end

    def validate_currency(currency)
      unless currency == self.class.base_currency || self.class.other_currencies[currency]
        raise ArgumentError, 'Invalid Currency: currency does not exist in configuration'
      end
    end

    def validate_amount(amount)
      raise ArgumentError, 'Invalid Amount: amount must be a number' unless amount.is_a?(Numeric)
    end
  end

end
