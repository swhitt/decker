require 'spec_helper'

RSpec.describe Decker::Card do
  let(:ace_of_spades)   { Decker::Card.new 'AS' }
  let(:king_of_clubs)   { Decker::Card.new 'KC' }
  let(:two_of_diamonds) { Decker::Card.new '2D' }

  describe '#initialize' do
    it 'raises an ArgumentError with invalid notation' do
      expect { Decker::Card.new 'foo!' }.to raise_error(ArgumentError)
    end

    it 'completes successfullly with valid notation' do
      expect { Decker::Card.new 'QH' }.to_not raise_error
    end
  end

  describe '#eql?' do
    let(:card) { Decker::Card.new 'KD' }

    context 'when the other card is the same suit and rank' do
      let(:other_card) { Decker::Card.new 'KD' }

      it 'is #eql? in both directions' do
        expect(card).to eql(other_card)
        expect(other_card).to eql(card)
      end
    end

    context 'when the other card is the same suit and different rank' do
      let(:other_card) { Decker::Card.new 'AD' }

      it 'is not #eql? in both directions' do
        expect(card).not_to eql(other_card)
        expect(other_card).not_to eql(card)
      end
    end
  end

  describe '#to_s' do
    context 'with no options' do
      it 'returns the correct English representation of the card' do
        expect(ace_of_spades.to_s).to eq('Ace of Spades')
        expect(king_of_clubs.to_s).to eq('King of Clubs')
        expect(two_of_diamonds.to_s).to eq('Two of Diamonds')
      end
    end

    context 'with the pretty option turned' do
      it 'returns the pretty version of the card' do
        expect(ace_of_spades.to_s(pretty: true)).to eq('A♠')
        expect(king_of_clubs.to_s(pretty: true)).to eq('K♣')
        expect(two_of_diamonds.to_s(pretty: true)).to eq('2♦')
      end
    end
  end
end
