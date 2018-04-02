require "rails_helper"

describe Player, :type => :model do
  context "Check player spec" do
    it "should have a name" do
      player = Player.new
      player.name = "John"
      expect(player.name).to eq("John")
    end
  end
end

describe Match, :type => :model do
  context "match creation" do
    it "will create a match" do
      match = Match.init_match
      player_array = ["John","Tom"]
      player_array.each do |player|
        match.games << Game.init_game(Player.init_player(player), match.word)
      end
      expect(match).to be_valid

    end
  end
end
