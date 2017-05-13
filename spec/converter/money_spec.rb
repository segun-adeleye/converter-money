require 'spec_helper'

module Converter
  describe Money do

    describe 'validations' do
      shared_examples 'unconfigured money' do
        it { expect(Money.base_currency).to be_nil }
        it { expect(Money.other_currencies).to be_nil }
      end

      context '.conversion_rates' do
        it { expect { Money.conversion_rates('EUR', {}) }.to raise_error(ArgumentError, 'Empty hash') }
        it { expect { Money.conversion_rates('EUR', 300) }.to raise_error(ArgumentError, 'Invalid Options: options must be a hash') }

        it_should_behave_like 'unconfigured money'
      end

      context 'when configuration is not set' do
        describe '#initialize' do
          it_should_behave_like 'unconfigured money'

          it 'raises ConfigurationError exception' do
            expect { Money.new(50, 'EUR') }.to raise_error(Money::ConfigurationError)
            expect(Money.base_currency).to be_nil
            expect(Money.other_currencies).to be_nil
          end
        end
      end
    end

    describe 'when configuration is set' do
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
        let(:usd_money)     { money.convert_to('USD') }
        let(:bitcoin_money) { money.convert_to('Bitcoin') }
        let(:same_money)    { money.convert_to('EUR') }
        let(:bitcoin_23)    { Money.new(23, 'Bitcoin') }
        let(:usd_87)        { Money.new(87, 'USD') }

        it 'returns instances of Money' do
          expect(usd_money).to be_an_instance_of Money
          expect(bitcoin_money).to be_an_instance_of Money
          expect(same_money).to be_an_instance_of Money
        end

        context 'conversion from base currency to other currencies' do
          it { expect(usd_money.inspect).to eq('55.50 USD') }
          it { expect(bitcoin_money.inspect).to eq('0.24 Bitcoin') }
        end

        context 'conversion from other currencies to base currency' do
          it { expect(usd_money.convert_to('EUR').inspect).to eq('50.00 EUR') }
          it { expect(bitcoin_money.convert_to('EUR').inspect).to eq('50.00 EUR') }

          it { expect(usd_87.convert_to('EUR').inspect).to eq('78.38 EUR') }
          it { expect(bitcoin_23.convert_to('EUR').inspect).to eq('4893.62 EUR') }
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

      describe 'validations' do
        context '#initialize' do
          it { expect{ Money.new('50', 'EUR') }.to raise_error(ArgumentError, 'Invalid Amount: amount must be a number') }
          it { expect{ Money.new(50, 'NGN') }.to raise_error(ArgumentError, 'Invalid Currency: currency does not exist in configuration') }
        end

        context '#convert_to' do
          it { expect { money.convert_to('NGN') }.to raise_error(ArgumentError, 'Invalid Currency: currency does not exist in configuration') }
        end
      end

      describe 'operations' do
        let(:fifty_eur)           { Money.new(50, 'EUR') }
        let(:twenty_eur)          { Money.new(20, 'EUR') }
        let(:twenty_dollars)      { Money.new(20, 'USD') }
        let(:two_bitcoins)        { Money.new(2, 'Bitcoin') }

        let(:fifty_eur_in_usd)    { fifty_eur.convert_to('USD') }
        let(:two_bitcoins_in_eur) { two_bitcoins.convert_to('EUR') }

        describe 'arithmetics operations' do
          it { expect(fifty_eur + twenty_dollars).to eq '68.02 EUR' }
          it { expect(twenty_dollars + fifty_eur).to eq '75.50 USD' }
          it { expect(twenty_eur + twenty_eur).to eq '40 EUR' }
          it { expect(two_bitcoins + twenty_eur).to eq '2.09 Bitcoin' }
          it { expect(two_bitcoins - twenty_eur).to eq '1.91 Bitcoin' }
          it { expect(fifty_eur - twenty_dollars).to eq '31.98 EUR' }
          it { expect(fifty_eur - twenty_eur).to eq '30 EUR' }
          it { expect(fifty_eur / 2).to eq '25 EUR' }
          it { expect(twenty_dollars * 3 ).to eq '60 USD' }
        end

        describe 'camparisons operations' do
          it { expect(twenty_dollars == Money.new(20, 'USD')).to be true }
          it { expect(twenty_dollars == Money.new(30, 'USD')).to be false }
          it { expect(fifty_eur_in_usd == fifty_eur).to be true }
          it { expect(twenty_dollars > Money.new(5, 'USD')).to be true }
          it { expect(twenty_dollars < fifty_eur).to be true }
          it { expect(two_bitcoins_in_eur == two_bitcoins).to be true }
        end
      end
    end

  end
end
