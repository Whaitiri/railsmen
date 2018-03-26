class Game < ApplicationRecord
  ALL_LETTERS = 'abcdefghijklmnopqrstuvwxyz'.split('')
  belongs_to :player
  belongs_to :match
  validates_associated :match
  validates :player_id, presence: true


  def self.init_game(player_input, word_input)
    game = Game.new
    game.current_guess = (word_input.split('').map {'_'}).join
    game.current_guesses = ""
    game.guesses_left = 7
    game.player = player_input
    return game
  end

  def remaining_letters
    return (ALL_LETTERS - self.current_guesses.split('')).join
  end

  def input_check(input) #returns false if incorrect letter, true if correct
    input = input.downcase
    self.current_guesses += input
    guess_fail = 0
    self.match.word.split('').each_with_index do |letter, i|
      if letter == input
        self.current_guess[i] = letter
      else
        guess_fail += 1
      end
    end
    unless guess_fail >= self.match.word.length
      return true
    else
      self.guesses_left -= 1
      return false
    end
  end

  def end_turn_check
    if self.match.word == self.current_guess
      return "win"
    elsif self.guesses_left <= 0
      return "loss"
    else
      return "ok"
    end

  end
end
