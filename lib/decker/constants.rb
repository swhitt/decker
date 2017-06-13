module Decker
  # The rank of a Card is the number or face value it has. This
  # maps the Symbol representation of rank to its English 
  # representation.
  RANKS = {
    '2': 'Two',
    '3': 'Three',
    '4': 'Four',
    '5': 'Five',
    '6': 'Six',
    '7': 'Seven',
    '8': 'Eight',
    '9': 'Nine',
      T: 'Ten',
      J: 'Jack',
      Q: 'Queen',
      K: 'King',
      A: 'Ace'
  }.freeze

  # Similar to the RANKS hash, the SUITS hash maps the Symbol
  # representation of a Card's suit to its English representation
  SUITS = {
    C: 'Clubs',
    D: 'Diamonds',
    H: 'Hearts',
    S: 'Spades'
  }.freeze

  # A Map between the Suit symbols and some nice unicode
  # symbols that represent the suits, suitable for display
  # or used in #inspect
  PRETTY_SUITS = Hash[SUITS.keys.zip(%w[♣ ♦ ♥ ♠])].freeze

  # a regular expression used to separate a Hand's full notation
  # into individual Card notations.
  ONE_CARD_REGEXP = /[#{RANKS.keys.join}][#{SUITS.keys.join}]/

  # a regular expression just to validate the notation for
  # an entire hand.
  HAND_REGEXP = /\A(#{ONE_CARD_REGEXP}\s?)+\Z/

  # the named capture groups in this regexp will allow us to 
  # grab the rank and suit of the desired card quickly without
  # messing with MatchData indices
  EXTRACT_RANK_AND_SUIT_REGEXP =
    /\A(?<rank>[#{RANKS.keys.join}])(?<suit>[#{SUITS.keys.join}])\Z/
end
