class IlmosController < ApplicationController

skip_before_filter :is_authenticated?

  def show

    @tournament = Tournament.find(params[:tournament_id])
    @calendar = Calendar.new
    @team = Team.new
    @player = Player.new
    @picture = Picture.new
    @registered_already = false
    if logged_in?
      # if logged in, we don't need so much details filled
      @user = current_user
      @user.players.each do |p|
        if p.tournament == @tournament
          @registered_already = true
        end
      end
    else
      # otherwise we create a whole new user
      @user = User.new
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tournament }
    end
    
  end    


  def create

    @tournament = Tournament.find(params[:tournament_id])
    @player = Player.new(params[:player])
    @player.status = :active

    if @tournament.team_game
      logger.info("searching for existing team with name: %s" % params[:team][:name])
      @team = Team.find(:first, :conditions => { :name => params[:team][:name], :tournament_id => @tournament.id } )
      
      if not @team
        @team = Team.new(params[:team])
      end
    end
      
    if logged_in?
      # if user is logged in, we need only player alias (and team)
      @user = current_user

      if @tournament.team_game      
        @team.tournament = @tournament
        @team.save!
        @player.team = @team
      end

      @player.user = @user
      @player.tournament = @tournament
      @player.save!
            
    else
      # if user is not logged in, we create new user with new calendar and such
      @user = User.new(params[:user])
      @calendar = Calendar.new(params[:calendar])
      if params[:picture] and params[:picture][:uploaded_picture]
        @picture = Picture.new(params[:picture])
      else
        @picture = nil
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
        
        if @picture
          @picture.user = @user
          @picture.save!
        end
        
      end
      
    end
    referee_mail = IlmoMailer.create_referee_message(@player)
    player_mail = IlmoMailer.create_player_message(@player)
    IlmoMailer.deliver(referee_mail)
    IlmoMailer.deliver(player_mail)
    flash[:notice] = 'Ilmoittautuminen rekisteröity! Tuomaristo ottaa sinuun vielä yhteyttä ennen peliä!'
    redirect_to root_path

  end

  
  # rescue ActiveRecord::RecordInvalid => e
    # @player.valid?
    # redirect_to :back
  # end

end

