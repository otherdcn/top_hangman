require_relative "dictionary_list"
require_relative "player"
require "colorize"

module Hangman
  class Game
    attr_reader :player_one, :player_two, :guesser
    def initialize(mode = 2, player_one = "Joe", player_two = "Ted")
      @player_one = Human.new(player_one)
      @player_two = if mode == 1
                      Human.new(player_two)
                    else
                      Computer.new
                    end
    end

    def play(rounds = 2)
      puts "Welcome #{player_one.name} and #{player_two.name}!"

      rounds.times do |round|
        puts "\n******************** Round #{round + 1} ********************".black.on_white
        set_guesser(round)
        puts "===> Round: #{round + 1}"
        puts "===> Guesser: #{guesser.name}"
      end
    end

    def set_guesser(round)
      if round.even?
        @guesser = player_one
      else
        @guesser = player_two.instance_of?(Human) ? player_two : player_one
      end
    end
  end
end

game = Hangman::Game.new(1)
game.play
