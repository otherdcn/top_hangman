require_relative "dictionary_list"
require_relative "player"

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

    def play
      puts "Welcome #{player_one.name} and #{player_two.name}!"
    end
  end
end

game = Hangman::Game.new
game.play
