require 'open-uri'
require 'ruby-poker'

# This is the way I'd probably do it in the real world (with some test coverage
# of course) but it kind of defeats the point of the exercise, eh? :)
# Requires the ruby gem `ruby-poker`, you can get it with
# `gem install ruby-poker`

scores = { player1: 0, player2: 0, tie: 0 }

open('https://projecteuler.net/project/resources/p054_poker.txt') do |f|
  f.each_line do |notation|
    hand1 = PokerHand.new(notation[0..13])
    hand2 = PokerHand.new(notation[15..28])

    case hand1 <=> hand2
    when 1
      scores[:player1] += 1
    when 0
      scores[:tie] += 1
    when -1
      scores[:player2] += 1
    end
  end
end

puts scores.inspect
# => {:player1=>376, :player2=>624, :tie=>0}
