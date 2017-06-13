require 'decker'
require 'thor'
module Decker
  class CLI < Thor
    desc 'problem54', 'Grab the Project Euler Problem 54 input text, score the hands and print the output'
    def problem_54
      puts 'Downloading `poker.txt`, parsing and scoring.'
      puts "results: #{Decker.parse_url.inspect}"
    end
    default_task :problem_54
  end
end
