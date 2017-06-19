require 'decker/version'
require 'decker/decker_error'
require 'decker/constants'
require 'decker/card'
require 'decker/hand_classifier'
require 'decker/hand'
require 'open-uri'

# Decker will parse poker hand notation and score the resultant hands
# for you. The notation for each hands should be in the format
# `"7C 5H KC QH JD AS KH 4C AD 4S"`, where the first 5 pairs represent
# the first player's hand and the second 5 pairs represent the second
# player's hand.
module Decker
  # @param notation [String] The string notation for two 5 card hands, i.e.
  #   "QD 5H 4D 5D KH 7H 3D JS KD 4H". The first 5 cards are for the first
  #  hand, the second 5 cards are for the second hand.
  # @return [Array<Hand, Hand>] the two hands specified by the notation
  def self.load_two_hands(notation)
    no_whitespace = notation.gsub(/\s+/, '')
    first_hand = no_whitespace[0..9]
    second_hand = no_whitespace[10..19]
    [Hand.new(first_hand), Hand.new(second_hand)]
  end

  # @param array [Array<String>] an array of strings each representing two
  #   five card hands.
  # @return [Hash<Symbol, Integer] a Hash with the key specifiying the entity
  #   and the value representing that entity's score (total number of hands won)
  def self.score_hand_array(array)
    scores = { player1: 0, player2: 0, tie: 0 }
    array.each do |notation|
      hand1, hand2 = load_two_hands(notation)
      case hand1 <=> hand2
      when 1 then scores[:player1] += 1
      when 0 then scores[:tie] += 1
      when -1 then scores[:player2] += 1
      end
    end
    scores
  end

  # Download a multiline hand-notation file from the web, parse the notation,
  # evaluate the hands and output the player scores.
  # @param url [String] the String representation of the URL where the text file
  #   is located
  # @return [Hash<Symbol, Integer>] a Hash with the keys representing an entity
  #   and the values representing that entity's cumulative score over the hands.
  def self.parse_url(url = 'https://projecteuler.net/project/resources/p054_poker.txt')
    file = open(url).read
    score_hand_array(file.split(/\n/))
  end
end
