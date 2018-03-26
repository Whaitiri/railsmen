require 'rails_helper'

RSpec.describe "players/show", type: :view do
  before(:each) do
    @player = assign(:player, Player.create!(:name => 'John'))
  end

  it "renders attributes in <p>" do
    render
  end
end
