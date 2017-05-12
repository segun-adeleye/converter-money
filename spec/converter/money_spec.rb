require 'spec_helper'

describe Converter::Money do
  let(:money) { Converter::Money.new(50000, 'NGN') }

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

  describe '#initialize' do
    it { expect(money).to be_an_instance_of Converter::Money }
  end

  describe '#amount' do
    it { expect(money.amount).to eq(50000) }
  end

  describe '#currency' do
    it { expect(money.currency).to eq('NGN') }
  end

  describe '#inspect' do
    it { expect(money.inspect).to eq('50000.00 NGN') }
  end
end
