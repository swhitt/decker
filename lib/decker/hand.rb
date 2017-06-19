
module Decker
  # A representation of a Hand of cards.
  class Hand
    include HandClassifier
    include Enumerable
    extend Forwardable
    def_delegators :@cards, :size, :each

    def initialize(cards)
      @cards = SortedSet.new
      self << cards
    end

    def valid_notation?(notation)
      HAND_REGEXP.match(notation)
    end

    def <<(*new_cards)
      if new_cards[0].is_a? String
        add_by_notation(new_cards[0])
      else
        @cards.merge(new_cards.flatten)
      end
    end

    def add_by_notation(notation)
      unless valid_notation?(notation)
        raise ArgumentError, "The string #{notation} is invalid Hand notation"
      end

      new_cards = notation.scan(ONE_CARD_REGEXP).map { |card| Card.new(card) }
      self << new_cards
    end

    def to_s
      @cards.map { |c| c.to_s(pretty: true) }.join ' '
    end

    def inspect
      "#<#{self.class}: #{self}>"
    end
  end
end
