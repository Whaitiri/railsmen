class Player < ApplicationRecord
  has_many :games
  accepts_nested_attributes_for :games
  has_many :matches, through: :games
  validates :name, presence: true, uniqueness: true
  validates_associated :games
  validates_length_of :name, :minimum => 1

  def self.init_player(name_input)
    player = Player.new
    player.name = name_input
    player.save
    return player
  end
end
