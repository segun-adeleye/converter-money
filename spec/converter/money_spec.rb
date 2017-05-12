require 'spec_helper'

describe Converter::Money do
  let(:money) { Converter::Money.new(50000, 'NGN') }

  before(:all) do
    Converter::Money.conversion_rates('NGN', {
      'USD' => 0.0031,
      'EUR' => 0.0029
    })
  end

  describe '.conversion_rates' do
    it 'sets configuration for conversion rates' do
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

  describe '#convert_to' do
    let(:eur_money) { money.convert_to('EUR') }
    let(:usd_money) { money.convert_to('USD') }
    let(:same_money) { money.convert_to('NGN') }

    it 'returns instances of Converter::Money' do
      expect(eur_money).to be_an_instance_of Converter::Money
      expect(usd_money).to be_an_instance_of Converter::Money
      expect(same_money).to be_an_instance_of Converter::Money
    end

    context 'conversion from base currency to other currencies' do
      it { expect(eur_money.inspect).to eq('145.00 EUR') }
      it { expect(usd_money.inspect).to eq('155.00 USD') }
    end

    context 'conversion to the same currency' do
      it 'returns same objects' do
        expect(money.convert_to('NGN')).to equal(money)
        expect(eur_money.convert_to('EUR')).to equal(eur_money)
        expect(usd_money.convert_to('USD')).to equal(usd_money)
      end

      it { expect(money.convert_to('NGN').inspect).to eq('50000.00 NGN') }
      it { expect(eur_money.convert_to('EUR').inspect).to eq('145.00 EUR') }
      it { expect(usd_money.convert_to('USD').inspect).to eq('155.00 USD') }
    end
  end
end
