class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :play, :play_update, :edit, :update, :destroy]
  before_action :set_turn_player, only: :play

  def index
    @matches = Match.all
  end

  def show
    # player.each do
    #   p
  end

  def new
    @match = Match.new
    @players_array = Player.all.collect{ |player| [player.name, player.id] }
  end

  def edit
  end

  def play

  end

  def play_update
    @game = @match.games[@match.current_game_id]
    if @game.input_check(params[:commit])
      return_notice = "Your guess was incorrect..."
    else
      return_notice = "Your guess was correct!"
    end

    if run_end_turn_checker
      @game.save
      return
    else
      if @game.save
        redirect_to action: "play", id: @match, notice: return_notice
        return
      else
        render :edit
        return
      end
    end
  end

  def create
    @match = Match.new
    @match.word = Match.generate_word

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

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:match)
    end

    def set_turn_player
      @match = Match.find(params[:id])
      if @match.current_game_id.nil?
        @match.current_game_id = @match.games.index(@match.games.first)
      else
        if @match.current_game_id >= (@match.games.length - 1)
          @match.current_game_id = 0
        else
          @match.current_game_id += 1
        end
      end
      @game = @match.games[@match.current_game_id]
      @match.save
    end

    def run_end_turn_checker
      if @game.end_turn_check == "win"
        flash[:notice] = "you won"
        redirect_to(action: "postgame", id: @game)
        return true
      elsif @game.end_turn_check == "loss"
        flash[:notice] = "you lost"
        redirect_to(action: "postgame", id: @game)
        return true
      else
        return false
      end
    end

end
