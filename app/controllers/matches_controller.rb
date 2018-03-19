class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]

  def index
    @matches = Match.all
  end

  def show
  end

  def new
    @match = Match.new
    @players_array = Player.all.collect{ |player| [player.name, player.id] }
  end

  def edit
  end

  def create
    selected_players_array = params[:selected_players].values
    unless selected_players_array.select{ |e| selected_players_array.count(e) > 1 } == []
      redirect_to new_match_url, notice: "Please select two different players"
      return
    end
    selected_players_array.each_with_index do |sp, i|
      byebug
      selected_players_array[i] = Player.find(sp.to_i)
    end
    # byebug
    @match = Match.new
    @match.game1 = Game.init_game
    @match.game1.player = selected_players_array[0] if selected_players_array[0]
    @match.game2 = Game.init_game
    @match.game2.player = selected_players_array[1] if selected_players_array[1]

    if @match.save
      redirect_to @match, notice: 'Match was successfully created.'
    else
      render :new
    end
  end

  def update
    if @match.update
      redirect_to @match, notice: 'Match was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @match.destroy
    redirect_to matches_url, notice: 'Match was successfully destroyed.'
  end

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.fetch(:match, {})
    end
end
