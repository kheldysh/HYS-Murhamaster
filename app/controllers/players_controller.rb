class PlayersController < ApplicationController

  before_filter :own_data?, :except => [:show, :index]
  before_filter :is_referee?, :only => [:show, :destroy]


  def index
    @tournament = Tournament.find(params[:tournament_id])
    @players = @tournament.players

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  def show
    @player = Player.find(params[:id])
    @user = @player.user
    @calendar = @user.calendar

  end

  # GET /tournaments/new
  # GET /tournaments/new.xml
  def new
  end

  # GET /tournaments/1/edit
  def edit
    @player = Player.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])
  end

  # POST /tournaments
  # POST /tournaments.xml
  def create
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

  # PUT /tournaments/1
  # PUT /tournaments/1.xml
  def update
    @player = Player.find(params[:id])
    @player.update_attributes(params[:player])
    @player.save!
    redirect_to :back
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.xml
  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to(tournaments_url) }
      format.xml  { head :ok }
    end
  end
  
  def is_referee?
    @player = Player.find(params[:id])
    current_user.referees.each do |ref|
      if ref.tournament == @player.tournament
        return true
      end
    end
    return false
  end
      
end
