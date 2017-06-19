require 'spec_helper'

RSpec.describe Decker::HandClassifier do
  let(:high_card_ace) { Decker::Hand.new 'AS 3D 4C 7H TC' }
  let(:high_card_ten) { Decker::Hand.new '2S 3D 4C 5H TD' }
  let(:royal_flush)   { Decker::Hand.new 'AS KS QS JS TS' }
  let(:aces_full_of_tens) { Decker::Hand.new 'AS AD AH TC TD' }
  let(:four_aces) { Decker::Hand.new 'AS AC AD AH TC' }

  describe 'royal flush predicate methods' do
    subject { royal_flush }
    it { is_expected.to be_high_card }
    it { is_expected.to_not be_one_pair }
    it { is_expected.to_not be_two_pair }
    it { is_expected.to_not be_three_of_a_kind }
    it { is_expected.to_not be_four_of_a_kind }
    it { is_expected.to be_straight }
    it { is_expected.to be_flush }
    it { is_expected.to_not be_full_house }
    it { is_expected.to_not be_two_pair }
  end

  describe 'full_boat predicate methods' do
    subject { aces_full_of_tens }
    it { is_expected.to be_high_card }
    it { is_expected.to_not be_straight }
    it { is_expected.to_not be_flush }
    it { is_expected.to be_full_house }
  end

  describe 'high card predicate methods' do
    subject { high_card_ace }
    it { is_expected.to be_high_card }
  end

  describe '#<=>' do
    it 'returns 1 when the first hand is better than the second' do
      expect(royal_flush <=> high_card_ace).to eql(1)
    end

    it 'returns 0 when the first hand is the same as the second' do
      # rubocop:disable Lint/UselessComparison
      expect(royal_flush <=> royal_flush).to eql(0)
      # rubocop:enable Lint/UselessComparison
    end

    it 'returns -1 when the first hand is worse than the second' do
      expect(high_card_ace <=> aces_full_of_tens).to eql(-1)
    end
  end
end
