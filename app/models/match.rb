class Match < ApplicationRecord
  belongs_to :game1, :class_name => 'Game'
  belongs_to :game2, :class_name => 'Game'
end
