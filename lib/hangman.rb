require_relative "dictionary_list"
require_relative "player"
require "colorize"
require "yaml"
require "json"

module Hangman
  class Game
    attr_reader :player_one, :player_two, :guesser
    attr_accessor :secret_word, :correct_letters_guessed, :letters_guessed
    @@serializers = [JSON, YAML, Marshal]

    def initialize(mode = 2, player_one = "Joe", player_two = "Ted")
      @player_one = Human.new(player_one)
      @player_two = if mode == 2 # mode 1 is single player mode
                      Human.new(player_two)
                    else
                      Computer.new # placeholder for single player mode
                    end
    end

    def set_reset_values
      self.correct_letters_guessed = Array.new(secret_word.size, "-")
      self.letters_guessed = []
    end

    def play(rounds = 2)
      puts "Welcome #{player_one.name} and #{player_two.name}!"
      puts "\n#{rounds} rounds to play!"

      rounds.times do |round|
        puts "\n******************** Round #{round + 1} ********************".black.on_white
        set_guesser(round)
        puts "===> Round: #{round + 1}"
        puts "===> Guesser: #{guesser.name}\n\n"

        set_secret_word
        set_reset_values

        wrong_guess_counter = 8
        until wrong_guess_counter.zero?
          puts "\n==> #{wrong_guess_counter} tries left".black.on_white

          break if correct_letters_guessed.join == secret_word.to_s

          print "Do you want to rest and save the game (y/n): "
          save_game_prompt_response = gets.chomp[0]

          if save_game_prompt_response == "y"
            save_game([rounds, round], wrong_guess_counter, 2)

            return "Gave saved and ended"
          else
            next if guess_secret_word

            wrong_guess_counter -= 1
          end
        end

        end_round(wrong_guess_counter)
      end

      announce_winner unless player_two.instance_of? Computer # no need to announce winner in single player game mode
    end

    def end_round(wrong_guess_counter)
      if wrong_guess_counter.zero?
        puts "\nHANGMAN!!!".red
        puts "Secret Word: #{secret_word}"
        puts "Your Guess: #{correct_letters_guessed.join}"
      else
        puts "\nYou got it!!!".green
        puts "Secret Word: #{secret_word}"
        puts "Your Guess: #{correct_letters_guessed.join}"
      end

      add_guesser_score(wrong_guess_counter)

      puts "SCOREBOARD".center(45).underline
      [player_one, player_two].each do |player|
        next if player.instance_of? Computer # only show player one (human) since its single player mode

        print player.name.to_s.ljust(15)
        puts "| #{player.score}"
      end

      print "\nPress any key to continue..."
      gets
    end

    def set_guesser(round)
      @guesser = if round.even?
                   player_one
                 else
                   player_two.instance_of?(Human) ? player_two : player_one
                 end
    end

    def set_secret_word
      self.secret_word = DictionaryList.new

      puts "The secret word has been set! It is #{secret_word.size} characters long.".yellow
    end

    def prompt_user_input
      puts "Correct guesses: #{correct_letters_guessed.join}"
      puts "Incorrect guesses: #{letters_guessed.join(', ')}"
      input_validity = false

      until input_validity
        print "Enter your guess (only one letter character, all else will be discarded): "
        begin
          guess_letter = gets.chomp[0].downcase
          input_validity = validate_letter_input(guess_letter)
        rescue NoMethodError # exception handling of calling downcase on nil "guess_letter"
          puts "Input empty; please type something...".yellow
        end
      end

      guess_letter
    end

    def validate_letter_input(guess_letter)
      input_empty_or_nil_or_not_string = guess_letter.nil? ||
                                         guess_letter.empty? ||
                                         !guess_letter.ord.between?(65, 122)
      input_already_guessed = letters_guessed.include? guess_letter
      input_already_correct = correct_letters_guessed.include? guess_letter

      if input_empty_or_nil_or_not_string
        puts "Input not a string".yellow
      elsif input_already_guessed
        puts "Input already guessed".yellow
      elsif input_already_correct
        puts "Input already correctly guessed".yellow
      else
        true
      end
    end

    def guess_secret_word
      guess_letter = prompt_user_input

      if secret_word.word.include? guess_letter
        secret_word_array = secret_word.split("")

        letter_indices = secret_word_array.each_index.select { |index| secret_word_array[index] == guess_letter }

        letter_indices.each do |index|
          correct_letters_guessed[index] = guess_letter
        end

        puts "#{guess_letter} is correct!".green
        true # correct guess attempt; do not decrement the wrong_guess_counter variable
      else
        letters_guessed << guess_letter

        puts "#{guess_letter} is wrong!".red
        false # wrong guess attempt; decrement the wrong_guess_counter variable
      end
    end

    def add_guesser_score(wrong_guess_counter)
      guesser.score += wrong_guess_counter # number of tries left is the score; the higher, the better
    end

    def announce_winner
      if player_one.score > player_two.score
        puts "Congratulations #{player_one.name}".green
      elsif player_one.score < player_two.score
        puts "Congratulations #{player_two.name}".green
      else
        puts "Draw".yellow
      end
    end

    def save_game(game_rounds, wrong_guess_counter, format = 1)
      game_properties = [player_one, player_two, guesser.name, secret_word, correct_letters_guessed, letters_guessed, game_rounds, wrong_guess_counter]
      serialize_format = @@serializers[format]

      puts "Serializing using #{serialize_format.name} format..."

      save_dump = serialize_format.dump game_properties

      save_dump_file = "saves/game-#{serialize_format.name.downcase}.save"

      puts "Saving to file #{save_dump_file}"

      File.open(save_dump_file, "w") do |file|
        file.write save_dump
      end
    end
  end
end

#game = Hangman::Game.new(2)
#game.play
