require 'spec_helper'

RSpec.describe Decker::Hand do
  let(:valid_notation) { 'AS 2D 3S 7S JS' }
  let(:valid_hand) { Decker::Hand.new(valid_notation) }
  let(:straight_flush) { Decker::Hand.new 'AS 2S 3S 4S 5S' }
  let(:ace_of_spades) { Decker::Card.new 'AS' }
  let(:queen_of_hearts) { Decker::Card.new 'QH' }

  describe '#initialize' do
    context 'when passed invalid notation' do
      it { expect { Decker::Hand.new 'foo!' }.to raise_error(ArgumentError) }
    end

    context 'when passed valid notation' do
      subject(:hand) { Decker::Hand.new(valid_notation) }

      it { expect { Decker::Hand.new(valid_notation) }.to_not raise_error }

      it 'is populated with the cards correctly' do
        expect(hand.size).to eql(5)
        is_expected.to include(ace_of_spades)
        is_expected.to_not include(queen_of_hearts)
      end
    end
  end

  describe 'a valid hand' do
    subject { valid_hand }
    it 'should be Enumerable and implement #each' do
      is_expected.to be_kind_of(Enumerable)
      is_expected.to respond_to(:each)
    end
  end
end
