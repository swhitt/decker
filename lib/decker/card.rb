module Decker
  # An immutable representation of one card in a
  # [Standard 52-card deck](https://en.wikipedia.org/wiki/Standard_52-card_deck).
  class Card
    include Comparable
    attr_reader :rank, :suit

    # Create a new Card object of a given rank and suit
    # @param notation [String] a two-character representation denoting the card rank/suit
    # @example A Card representing the King of Diamonds
    #   Decker::Card.new 'KD'
    def initialize(notation)
      unless parsed_notation = EXTRACT_RANK_AND_SUIT_REGEXP.match(notation)
        raise ArgumentError, "The string #{notation.inspect} is invalid Card notation"
      end

      @rank = parsed_notation[:rank].to_sym
      @suit = parsed_notation[:suit].to_sym
    end

    # An English representation of the card.
    # @example The ten of clubs
    #   Decker::Card.new('TC').to_s #=> "Ten of Clubs"
    def to_s(pretty: false)
      if pretty
        "#{@rank}#{PRETTY_SUITS[@suit]}"
      else
        "#{RANKS[@rank]} of #{SUITS[@suit]}"
      end
    end

    # A Hand is essentially just a Set of Cards; in order to get proper
    # behavior with a Set (which uses a Hash in its implementation)
    # we have to make sure Card has #eql? and #hash defined properly
    #
    # @param other [Card] the other Card we're comparing to
    def ==(other)
      other.is_a?(self.class) &&
        other.rank == @rank &&
        other.suit == @suit
    end

    alias eql? ==

    # The card's hash function is just the suit and rank hashes XOR'd together
    def hash
      @rank.hash ^ @suit.hash
    end

    def inspect
      "#<#{self.class}:#{to_s(pretty: true)}>"
    end
  end
end
