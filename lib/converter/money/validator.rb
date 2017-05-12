module Converter
  module Validator
    module ClassMethods
      private
        def validate_conversion_rates(base_currency, other_currencies)
          raise ArgumentError, 'Invalid Options: options must be a hash' unless other_currencies.is_a? Hash
          raise ArgumentError, 'Empty hash' if other_currencies.empty?
        end
    end

    module InstanceMethods
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
          raise ArgumentError, 'Invalid Amount: amount must be a number' unless amount.is_a? Numeric
        end
    end

    def self.included(base)
      base.extend   ClassMethods
      base.include  InstanceMethods
    end
  end

end
