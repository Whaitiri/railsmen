require 'rails_helper'

RSpec.describe "players/index", type: :view do
  before(:each) do
    assign(:players, [
      Player.create!(:name => 'John'),
      Player.create!(:name => 'Dave')
    ])
  end

  it "renders a list of players" do
    render
  end
end
