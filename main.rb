require "colorize"
require_relative "lib/hangman"

puts %{
Welcome to Hangman... a guessing game that can be played by two or
more players.

In this version, the computer will set a secret word and you (the
players) will have tries to guess it by suggesting letters within a
certain number of guesses.

This game tests your vocabulary. Make sure you crack it before the
poor stick figure meets its doom :-D
}

def validate_input(input,num_of_options)
  if input.between?(1, num_of_options)
    true
  else
    puts "Wrong input; please type numbers between 1 and #{num_of_options}; try again".yellow
  end
end

def prompt_user_input(options)
  input_validity = false

  until input_validity
    print "Select number [1 or 2 or 3]: "
    input = gets.chomp.strip.to_i
    input_validity = validate_input(input, options)
  end

  input
end

def start_new_game
  puts "Starting new game..."

  puts "\nWould you like to play:"
  puts "1. Single player"
  puts "2. Multipler"
  game_mode_input = prompt_user_input(2)

  game_rounds_input = 1 # default number of rounds until changed in multipler mode

  game = if game_mode_input == 1
           puts "\nSelected Single player"
           print "Enter Player name: "
           player_one_name = gets.chomp.strip

           Hangman::Game.new(game_mode_input, {name: player_one_name, score: 0})
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
           game_rounds_input = prompt_user_input(3)
           game_rounds_input *= 2 # multiplied to match the value of the selection

           Hangman::Game.new(game_mode_input, {name: player_one_name, score: 0}, {name: player_two_name, score: 0})
         end

  game.play([game_rounds_input,1])
end

def load_saved_game
  puts "Loading saved game"
  begin
    game, guesser, secret_word, correct_letters_guessed, letters_guessed, rounds, wrong_guess_counter = Hangman::Game.load_game

    game.guesser = guesser
    game.secret_word = secret_word
    game.correct_letters_guessed = correct_letters_guessed
    game.letters_guessed = letters_guessed

    game.play(rounds, wrong_guess_counter, true)
  rescue Errno::ENOENT
    puts "No saved game, perhaps start a new game"
  end
end

puts "\nLoad saved game, or start new:"
puts "1. Load previous game"
puts "2. Start new game"
load_or_new = prompt_user_input(2)

if load_or_new == 1
  load_saved_game
else
  start_new_game
end
