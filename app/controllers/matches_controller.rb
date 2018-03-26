class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :play, :play_update, :edit, :update, :destroy]
  before_action :set_game, only: [:play, :play_update]
  before_action :redirect_to_postgame, only: [:play, :show]

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
    @match = Match.init_match

    selected_players_array = params[:selected_players].values
    unless selected_players_array.select{ |e| selected_players_array.count(e) > 1 } == []
      redirect_to new_match_url, notice: "Please select two different players"
      return
    end

    selected_players_array.each_with_index do |sp, i|
      if Player.find_by_id(sp.to_i)
        selected_players_array[i] = Player.find(sp.to_i)
        @match.games << Game.init_game(selected_players_array[i], @match.word)
      else
        selected_players_array.delete_at(i)
      end
    end

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

  def play
  end

  def play_update
    if @game.input_check(params[:commit])
      return_notice = "Your guess was correct!"
    else
      return_notice = "Your guess was incorrect..."
    end

    if @game.current_guess == @game.match.word
      return_notice = "#{@game.player.name} has guessed the word!"
      @match.game_won = 1
      @match.save
      redirect_to @match
    end

    if @match.check_players
      return_notice = "No guesses left"
      @match.game_won = 1
      @match.save
      redirect_to @match
      return
    end

    if @game.save
      @game = @match.set_turn_player unless @game.input_check(params[:commit])
      redirect_back fallback_location: { action: "play", id: @match }, id: @match, notice: return_notice
      return
    else
      render :edit
      return
    end
  end

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def set_game
      @game = @match.games[@match.current_game_id]
    end

    def match_params
      params.require(:match)
    end

    def redirect_to_postgame
      if @match.game_won == 1
        render :postgame
        return
      end
    end
    # def end_check
    #   if @game.guesses_left <= 0
    #     return_notice = "#{@game.player.name} has no guesses left!"
    #     @game = @match.set_turn_player
    #     redirect_back fallback_location: { action: "play", id: @match }, id: @match, notice: return_notice
    #     return
    #   end
    # end

    # def run_end_turn_checker
      # if @game.end_turn_check == "win"
      #   flash[:notice] = "you won"
      #   redirect_to(action: "play", id: @game)
      #   return true
      # elsif @game.end_turn_check == "loss"
      #   flash[:notice] = "you lost"
      #   redirect_to(action: "play", id: @game)
      #   return true
      # else
      #   return false
      # end
    # end

end
