require "colorize"
require_relative "lib/hangman"

def validate_mode_input(input)
  if input.between?(1, 2)
    true
  else
    puts "Wrong input; please type 1 or 2; try again".yellow
  end
end

def validate_rounds_input(input)
  if input.between?(1, 3)
    true
  else
    puts "Wrong input; please type 1, 2, or 3; try again".yellow
  end
end

puts %{
Welcome to Hangman... a guessing game that can be played by two or
more players.

In this version, the computer will set a secret word and you (the
players) will have tries to guess it by suggesting letters within a
certain number of guesses.

This game tests your vocabulary. Make sure you crack it before the
poor stick figure meets its doom :-D
}

puts "\nWould you like to play:"
puts "1. Single player"
puts "2. Multipler"

input_validity = false
until input_validity
  print "Select number [1 or 2]: "
  game_mode_input = gets.chomp.strip.to_i
  input_validity = validate_mode_input(game_mode_input)
end

game_rounds_input = 1 # default number of rounds until changed in multipler mode

game = if game_mode_input == 1
         puts "\nSelected Single player"
         print "Enter Player name: "
         player_one_name = gets.chomp.strip

         Hangman::Game.new(game_mode_input, player_one_name)
       else
         puts "\nSelected Multiplayer"
         print "Enter Player 1 name: "
         player_one_name = gets.chomp.strip

         print "Enter Player 2 name: "
         player_two_name = gets.chomp.strip

         print "\nHi #{player_one_name} and #{player_two_name}, "
         puts "how many rounds of game:"
         puts "1. 2"
         puts "2. 4"
         puts "3. 6"

         input_validity = false
         until input_validity
           print "Select number [1-3]: "
           game_rounds_input = gets.chomp.strip.to_i
           input_validity = validate_rounds_input(game_rounds_input)
         end

         game_rounds_input *= 2 # multiplied to match the value of the selection

         Hangman::Game.new(game_mode_input, player_one_name, player_two_name)
       end

game.play(game_rounds_input)
