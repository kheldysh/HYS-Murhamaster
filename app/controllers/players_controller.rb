class PlayersController < ApplicationController

  before_filter :own_data?, :except => [:show, :index, :update]
  before_filter :is_referee?, :only => [:index, :show, :update, :destroy]


  def index
    @tournament = Tournament.find(params[:tournament_id])
    @players = @tournament.players
  end

  def show
    @player = Player.find(params[:id])
    @user = @player.user
    @calendar = @user.calendar
  end

  def new
  end

  def edit
    @player = Player.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])
  end

  def create
    # FIXME this is creation for _tournament_, not player :(
    @tournament = Tournament.new(params[:tournament])

    respond_to do |format|
      if @tournament.save
        flash[:notice] = 'Tournament was successfully created.'
        format.html { redirect_to(@tournament) }
        format.xml  { render :xml => @tournament, :status => :created, :location => @tournament }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tournament.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @player = Player.find(params[:id])
    @player.update_attributes(params[:player])
    @player.save!
    @tournament = Tournament.find(params[:tournament_id])
    redirect_to tournament_players_path(@tournament)
  end

  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy
  end
  
  def is_referee? # before_filter
    @tournament = Tournament.find(params[:tournament_id])
    current_user.referees.each do |ref|
      if ref.tournament == @tournament
        return true
      end
    end
    return false
  end
      
end
