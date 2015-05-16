class PicturesController < ApplicationController

  before_filter :is_owner_or_referee?, :only => [:edit, :update, :create]
  before_filter :is_own_or_targets_picture?, :only => :display

  def edit
    @picture = Picture.new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])

    begin
      if params[:picture]
        logger.info("Picture of #{params[:picture][:photo].size} bytes uploaded")
        @picture = Picture.new(:photo => params[:picture][:photo])
        logger.info(@picture.photo.s3_credentials)
        @picture.user = @user
        @user.picture = @picture
        @picture.save
        @user.save
        flash[:notice] = 'Kuva on vaihdettu!'
        redirect_to root_path
      else
        flash[:alert] = 'Ei kuvaa!'
        redirect_to edit_user_pictures_path(@user)
      end
    rescue Exception => e
      logger.info(e)
      logger.info(e.backtrace)
    end
    # redirect_to edit_user_path(@user)
  end

  def get
    Picture.find(params[:id])
  end

  def update
    create
  end

  def display
    picture = Picture.find_by_id(params[:id])
    head(:not_found) and return unless picture
    redirect_to picture.authenticated_url(params[:display])
  end

  def is_own_or_targets_picture?
    logger.info "is_own_or_targets_picture"
    @picture = Picture.find(params[:id])

    if current_user == @picture.user
      logger.info "is current user"
      return true
    elsif current_user.admin
       logger.info "is admin"
       return true
    end
    current_user.players.each do |player|
      if player.tournament.is_running?
        @picture.user.players.each do |pic_player|
          if player.targets.include? pic_player
            logger.info "hunter watching"
            return true
          end
        end
      end
    end
    current_user.referees.each do |referee|
      if referee.tournament.is_relevant_for_referee?
        @picture.user.players.each do |pic_player|
          if pic_player.tournament == referee.tournament
            logger.info "referee watching"
            return true
          end
        end
      end
    end

    redirect_to root_path
  end


  def is_own_picture?
    if current_user.id == params[:user_id].to_i
      logger.info "is own picture"
      return true
    elsif current_user.admin
      logger.info "user is admin"
      return true
    end
    logger.info "current user: id=%d" % current_user.id
    redirect_to root_path
  end

end

