require 'decker'
require 'thor'
module Decker
  # The entrypoint for the `decker` command line interface.
  class CLI < Thor
    desc 'problem54',
         'Grab the Project Euler input, score the hands and print the output'
    def problem_54
      puts 'Downloading `poker.txt`, parsing and scoring.'
      puts "results: #{Decker.parse_url.inspect}"
    end
    default_task :problem_54
  end
end
