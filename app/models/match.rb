class Match < ApplicationRecord
  has_many :games
  has_many :players, -> {order (:id)}, through: :games
  validates_length_of :games, minimum: 1, maximum: 2

  def self.generate_word
    wordList = []
    File.open("/usr/share/dict/words").each do |line|
      line = line.strip
      if line.strip.length > 7 or line.strip.length < 4
        next
      elsif line[0].match(/^[A-Z]/)
        next
      else
        wordList << line.strip
      end
    end
    return wordList[rand(0...wordList.count)]
  end

  def set_turn_player
    if self.current_game_id >= (self.games.length - 1)
      self.current_game_id = 0
    else
      self.current_game_id += 1
    end
    self.save
    return self.games[self.current_game_id]
  end
end
