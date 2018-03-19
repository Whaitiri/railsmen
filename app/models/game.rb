class Game < ApplicationRecord
  ALL_LETTERS = 'abcdefghijklmnopqrstuvwxyz'.split('')
  belongs_to :player
  has_many :matches, inverse_of: 'game1', :class_name => 'Match', :foreign_key => 'game1_id'
  has_many :matches, inverse_of: 'game2', :class_name => 'Match', :foreign_key => 'game2_id'
  validates :player_id, presence: true


  def self.init_game
    game = Game.new
    game.word = generate_word
    game.current_guess = (game.word.split('').map {'_'}).join
    game.current_guesses = ""
    game.guesses_left = 7
    game.save
    return game
  end

  def self.generate_word
    wordList = []
    File.open("/usr/share/dict/words").each do |line|
      line = line.strip
      if line.strip.length > 7 or line.strip.length < 3
        next
      elsif line[0].match(/^[A-Z]/)
        next
      else
        wordList << line.strip
      end
    end
    return wordList[rand(0...wordList.count)]
  end

  def remaining_letters
    return (ALL_LETTERS - self.current_guesses.split('')).join
  end

  def input_check(input) #returns false if incorrect letter, true if correct
    input = input.downcase
    self.current_guesses += input
    i = 0
    guess_fail = 0
    self.word.split('').each do |letter|
      if letter == input
        self.current_guess[i] = letter
      else
        guess_fail += 1
      end
      i += 1
    end

    unless guess_fail >= i
      return false
    else
      self.guesses_left -= 1
      return true
    end
  end

  def end_turn_check
    if self.word == self.current_guess
      return "win"
    elsif self.guesses_left <= 0
      return "loss"
    else
      return "ok"
    end

  end
end
