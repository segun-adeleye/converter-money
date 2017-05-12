require 'spec_helper'

module Converter
  describe Money do
    let(:money) { Money.new(50, 'EUR') }

    before(:all) do
      Money.conversion_rates('EUR', {
        'USD' => 1.11,
        'Bitcoin' => 0.0047
      })
    end

    describe '.conversion_rates' do
      it 'sets configuration for conversion rates' do
        expect(Money.base_currency).to eq('EUR')
        expect(Money.other_currencies).to eq({
          'USD' => 1.11,
          'Bitcoin' => 0.0047
        })
      end
    end

    describe '#initialize' do
      it { expect(money).to be_an_instance_of Money }
    end

    describe '#amount' do
      it { expect(money.amount).to eq(50) }
    end

    describe '#currency' do
      it { expect(money.currency).to eq('EUR') }
    end

    describe '#inspect' do
      it { expect(money.inspect).to eq('50.00 EUR') }
    end

    describe '#convert_to' do
      let(:usd_money) { money.convert_to('USD') }
      let(:bitcoin_money) { money.convert_to('Bitcoin') }
      let(:same_money) { money.convert_to('EUR') }

      it 'returns instances of Money' do
        expect(usd_money).to be_an_instance_of Money
        expect(bitcoin_money).to be_an_instance_of Money
        expect(same_money).to be_an_instance_of Money
      end

      context 'conversion from base currency to other currencies' do
        it { expect(usd_money.inspect).to eq('55.50 USD') }
        it { expect(bitcoin_money.inspect).to eq('0.24 Bitcoin') }
      end

      context 'conversion to the same currency' do
        it 'returns same objects' do
          expect(money.convert_to('EUR')).to equal(money)
          expect(usd_money.convert_to('USD')).to equal(usd_money)
          expect(bitcoin_money.convert_to('Bitcoin')).to equal(bitcoin_money)
        end

        it { expect(money.convert_to('EUR').inspect).to eq('50.00 EUR') }
        it { expect(usd_money.convert_to('USD').inspect).to eq('55.50 USD') }
        it { expect(bitcoin_money.convert_to('Bitcoin').inspect).to eq('0.24 Bitcoin') }
      end
    end
  end
end
