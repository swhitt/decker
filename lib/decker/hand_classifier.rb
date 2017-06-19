module Decker
  # The `HandClassifier` is used as a mixin to the `Deck` to do all hand
  # classification / comparison.
  # The methods to determine the type of hand a given hand is, the relative
  # score of that hand compared to another as well as the tiebreaker scores
  # are contained here.
  module HandClassifier
    # This is an ordered hash (from lowest to highest value Hand classification)
    # used for determining a Hand's classifications. The value lambdas are
    # iterated on sequentially and used as predicates for each classification.
    CLASSIFICATIONS = {
            high_card: ->(hand) { hand.high_card? },
             one_pair: ->(hand) { hand.one_pair? },
             two_pair: ->(hand) { hand.two_pair? },
      three_of_a_kind: ->(hand) { hand.three_of_a_kind? },
             straight: ->(hand) { hand.straight? },
                flush: ->(hand) { hand.flush? },
           full_house: ->(hand) { hand.full_house? },
       four_of_a_kind: ->(hand) { hand.four_of_a_kind? },
       straight_flush: ->(hand) { hand.flush? && hand.straight? }
    }.freeze

    # If we are comparing two hands of the same classification type this ordered
    # hash is used to break ties. Each lambda returns an array of scores for
    # that hand and classification type.
    TIE_BREAKERS = {
            high_card: ->(hand) { [hand.max.rank_index] },
             one_pair: lambda do |hand|
                         hand.scores_of_ranks_with_freq(2) + hand.kicker_scores
                       end,
             two_pair: ->(hand) { hand.scores_of_ranks_with_freq(2) },
      three_of_a_kind: ->(hand) { hand.scores_of_ranks_with_freq(3) },
             straight: ->(hand) { [hand.max.rank_index] },
                flush: ->(hand) { [hand.max.rank_index] },
           full_house: ->(hand) { [hand.max.rank_index] },
       four_of_a_kind: ->(hand) { hand.scores_of_ranks_with_freq(4) },
       straight_flush: ->(hand) { [hand.max.rank_index] }
    }.freeze

    # @return [Array<Hash>] an array of the classifications this Hand belongs
    #   to in increasing classification value. Each hash contains the following
    #   keys:
    #     * :name [Symbol] a name of a classification that applies to this Hand
    #     * :class_score [Integer] the score of that class, used for comparison
    #     * :tie_breakers [Array<Integer>] the tie breaker scores for this
    #       classification.
    def classify
      raise_if_invalid_count!
      classifications = []
      CLASSIFICATIONS.each do |class_name, predicate|
        # the predicate is a lambda that is passed a hand
        # and returns true/false if we fit within `classification_name`.
        class_applies = predicate.call(self)
        next unless class_applies

        # we only get here if the class we're checking applies -
        # now we add it to the result set of classes.
        classifications << { name: class_name,
                      class_score: class_score_for(class_name),
                     tie_breakers: tie_breaker_scores_for(class_name) }
      end
      classifications
    end

    def class_score_for(class_name)
      CLASSIFICATIONS.keys.index(class_name)
    end

    def tie_breaker_scores_for(class_name)
      TIE_BREAKERS[class_name].call(self)
    end

    def raise_if_invalid_count!
      raise IncorrectHandSizeError if size != 5
    end

    # @return [Boolean] Returns whether this Hand is a Full House
    def full_house?
      potential_top = Set.new(ranks_with_freq(3))
      potential_bottom = Set.new(ranks_with_freq(2))
      potential_top.count.positive? && potential_bottom.count > 1
    end

    # @return [Boolean] Returns whether this Hand is a Flush
    def flush?
      suits_with_freq(5).count.positive?
    end

    # @return [Boolean] Returns whether this Hand is a Straight
    def straight?
      deltas = map(&:rank_index).each_cons(2).map { |a, b| b - a }
      deltas.all? { |delta| delta == 1 }
    end

    # @return [Boolean] Returns whether this Hand contains Four of a Kind
    def four_of_a_kind?
      ranks_with_freq(4).count.positive?
    end

    # @return [Boolean] Returns whether this Hand contains Three of a Kind
    def three_of_a_kind?
      ranks_with_freq(3).count.positive?
    end

    # @return [Boolean] Returns whether this Hand contains Two Pair
    def two_pair?
      ranks_with_freq(2).count > 1
    end

    # @return [Boolean] Returns whether this Hand contains One Pair
    def one_pair?
      ranks_with_freq(2).count.positive?
    end

    # @return [true] Returns true as a poker hand can always be classified as
    #   having a High Card
    def high_card?
      true
    end

    # @return [Hash<Symbol,Integer>] A mapping from suit to that suit's
    #   frequency in the hand
    def frequency_by_suit
      each_with_object(Hash.new(0)) { |card, acc| acc[card.suit] += 1 }
    end

    # @param freq [Integer] We'll return all suits that occur with this
    #   frequency or higher in the hand
    # @return [Array<Symbol>] A list of the suits that meet the frequency
    #   criteria
    def suits_with_freq(freq)
      frequency_by_suit.select { |_r, f| f >= freq }.keys
    end

    # @return [Hash<Symbol,Integer>] A mapping from rank to that rank's
    #   frequency in the hand
    def frequency_by_rank
      each_with_object(Hash.new(0)) { |card, acc| acc[card.rank] += 1 }
    end

    # @param freq [Integer] We'll return all ranks that occur with this
    #   frequency or higher in the hand
    # @return [Array<Symbol>] A list of the ranks that meet the frequency
    #   criteria
    def ranks_with_freq(freq)
      frequency_by_rank.select { |_r, f| f >= freq }.keys
    end

    # The scores of ranks are used to break ties between two cards of the same
    # classification (i.e. two two-pair hands would be evaluated by first
    # comparing the scores of the higher-ranked pairs followed by comparing
    # the scores of the lower-ranked pairs).
    # @param freq [Integer] get the scores of the ranks in this hand that occur
    #   at this frequency or higher
    # @return [Array<Integer>] the scores of those ranks in descending order
    def scores_of_ranks_with_freq(freq)
      indexes = ranks_with_freq(freq).map { |r| Decker::RANKS.keys.index(r) }
      indexes.sort.reverse
    end

    # For breaking ties we get the rank scores of the ranks with frequency 1 in
    # descending order; this can be merged onto the end of the ties arrays and
    # used as a final tiebreaker.
    # @return
    def kicker_scores
      kicker_ranks = frequency_by_rank.select { |_r, f| f == 1 }.keys
      kicker_ranks.map { |r| Decker::RANKS.keys.index(r) }.sort.reverse
    end

    # Compare two Hands.
    # The actual meat of the hand classifier, where we compare hands. We take
    # the classifications of both this card and the other one and compare their
    #  class scores. If there are any ties then we compare the ties scores for
    # that classification type.
    # @return [Integer] 1 if this hand has a higher value than the other, -1 if
    #   the other hand has a higher
    def <=>(other)
      our_type = classify.last
      other_type = other.classify.last
      comparison = our_type[:class_score] <=> other_type[:class_score]
      return comparison unless comparison.zero?
      our_type[:tie_breakers] <=> other_type[:tie_breakers]
    end
  end
end
