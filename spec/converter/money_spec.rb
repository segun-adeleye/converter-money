require 'spec_helper'

describe Converter::Money do
  describe '.conversion_rates' do
    it 'sets configuration for conversion rates' do
      Converter::Money.conversion_rates('NGN', {
        'USD' => 0.0031,
        'EUR' => 0.0029
      })

      expect(Converter::Money.base_currency).to eq('NGN')
      expect(Converter::Money.other_currencies).to eq({
        'USD' => 0.0031,
        'EUR' => 0.0029
      })
    end
  end
end
