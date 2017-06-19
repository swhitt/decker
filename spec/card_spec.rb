require 'spec_helper'

RSpec.describe Decker::Card do
  let(:ace_of_spades)   { Decker::Card.new 'AS' }
  let(:king_of_clubs)   { Decker::Card.new 'KC' }
  let(:two_of_diamonds) { Decker::Card.new '2D' }
  let(:ace_of_clubs)    { Decker::Card.new 'AC' }
  let(:five_of_hearts)  { Decker::Card.new '5H' }
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

    context 'with the pretty option enabled' do
      it 'returns the pretty version of the card' do
        expect(ace_of_spades.to_s(pretty: true)).to eq('A♠')
        expect(king_of_clubs.to_s(pretty: true)).to eq('K♣')
        expect(two_of_diamonds.to_s(pretty: true)).to eq('2♦')
      end
    end
  end

  describe '#<=>' do
    it 'returns 1 if the other card has a lower rank' do
      expect(ace_of_spades <=> king_of_clubs).to equal(1)
      expect(five_of_hearts <=> two_of_diamonds).to equal(1)
    end

    it 'returns 0 if the other card has the same rank' do
      expect(ace_of_spades <=> ace_of_clubs).to equal(0)
    end

    it 'returns 0 if the other card is the same card' do
      # rubocop:disable Lint/UselessComparison
      expect(ace_of_spades <=> ace_of_spades).to equal(0)
      # rubocop:enable Lint/UselessComparison
    end

    it 'returns -1 if the other card has a higher rank' do
      expect(two_of_diamonds <=> five_of_hearts).to equal(-1)
    end
  end
end
