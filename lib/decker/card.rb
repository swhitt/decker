module Decker
  class Card
    include Comparable
    attr_reader :rank, :suit

    def initialize(notation)
      unless parsed_notation = EXTRACT_RANK_AND_SUIT_REGEXP.match(notation)
        raise ArgumentError, "The string #{notation.inspect} is invalid Card notation"
      end

      @rank = parsed_notation[:rank].to_sym
      @suit = parsed_notation[:suit].to_sym
    end

    # An English representation of the card.
    def to_s
      "#{RANKS[@rank]} of #{SUITS[@suit]}"
    end

    # A Hand is essentially just a Set of Cards; in order to get proper
    # behavior with a Set (which uses a Hash in its implementation)
    # we have to make sure Card has #eql? and #hash defined properly
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
      "#<#{self.class}:#{to_s}>"
    end
  end
end
