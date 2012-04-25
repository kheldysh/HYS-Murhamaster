class PicturesController < ApplicationController

  before_filter :is_owner_or_referee?, :only => [:edit, :update, :create]
  before_filter :is_own_or_targets_picture?, :only => :display

  def edit
    @picture = Picture.new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])

    if params[:picture]
      logger.info(params[:picture][:uploaded_picture].size)
      @picture = Picture.new(params[:picture])
      @picture.user = @user
      @user.picture = @picture
      @picture.save!
      @user.save!
      flash[:notice] = 'Kuva on vaihdettu!'
      redirect_to root_path
    else
      flash[:alert] = 'Ei kuvaa!'
      redirect_to edit_user_pictures_path(@user)
    end
  end

  def update
    create
  end

  def display

    logger.info "picturesController engaged"
    @picture = Picture.find(params[:file_name][1])
      send_data(
        @picture.data,
        :type => @picture.content_type,
        :filename => @picture.name,
        :disposition => 'inline'
      )

  end


  def is_own_or_targets_picture?
    @picture = Picture.find(params[:file_name][1])

    if current_user == @picture.user
      return true
    elsif
      current_user.players.each do |player|
        if player.tournament.is_running?
          @picture.user.players.each do |pic_player|
            if player.targets.include? pic_player
              return true
            end
          end
        end
      end
    else
      return false
    end
  end


  def is_own_picture?
    if current_user.id == params[:user_id].to_i
      logger.info "is own picture"
      return true
    else current_user.admin
      logger.info "user is admin"
      return true
    end
    logger.info "current user: id=%d" % current_user.id
    redirect_to root_path
    return false
  end

end

