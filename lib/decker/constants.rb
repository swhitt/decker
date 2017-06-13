module Decker
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

  SUITS = {
    C: 'Clubs',
    D: 'Diamonds',
    H: 'Hearts',
    S: 'Spades'
  }.freeze

  PRETTY_SUITS = Hash[SUITS.keys.zip(%w[♣ ♦ ♥ ♠])].freeze

  ONE_CARD_REGEXP = /[#{RANKS.keys.join}][#{SUITS.keys.join}]/

  HAND_REGEXP = /\A(#{ONE_CARD_REGEXP}\s?)+\Z/

  EXTRACT_RANK_AND_SUIT_REGEXP =
    /\A(?<rank>[#{RANKS.keys.join}])(?<suit>[#{SUITS.keys.join}])\Z/
end
