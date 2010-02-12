class IlmosController < ApplicationController

skip_before_filter :is_authenticated?

  def show
    @tournament = Tournament.find(params[:tournament_id])
    
    @team = Team.new
        
    @user = User.new
    @player = Player.new
    @calendar = Calendar.new
    @picture = Picture.new
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tournament }
    end
  end    


  def create
    @tournament = Tournament.find(params[:tournament_id])
    @user = User.new(params[:user])
    @player = Player.new(params[:player])
    @calendar = Calendar.new(params[:calendar])
    @picture = Picture.new(params[:picture])


    if @tournament.team_game
      @team = Team.find(:first, :conditions => { :name => params[:team][:id], :tournament_id => @tournament.id } )
      
      if not @team
        @team = Team.new(params[:team])
      end
    end
    
    
    User.transaction do
      @user.save!

      @calendar.user = @user
      @calendar.save!

      if @tournament.team_game      
        @team.tournament = @tournament
        @team.save!
        @player.team = @team
      end

      @player.user = @user
      @player.tournament = @tournament
      @player.save!
      
     
      @picture.user = @user
      @picture.save!
      
      
      
      flash[:notice] = 'Ilmoittautuminen rekisteröity! Tuomaristo ottaa sinuun vielä yhteyttä ennen peliä!'
      redirect_to root_path
    end
    
  end
  
  # rescue ActiveRecord::RecordInvalid => e
    # @player.valid?
    # redirect_to :back
  # end

end

