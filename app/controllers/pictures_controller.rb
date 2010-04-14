class PicturesController < ApplicationController

  before_filter :is_own_picture?, :only => [:edit, :update]
  before_filter :is_own_or_targets_picture?, :only => :display
  
  def edit
    @picture = Picture.new
    @user = User.find(params[:user_id])
  end

  def create
    logger.info(params[:picture][:uploaded_picture].size)
    @picture = Picture.new(params[:picture])
    @user = User.find(params[:user_id])
    @picture.user = @user
    @picture.save!
    flash[:notice] = 'Kuva on vaihdettu!'
    redirect_to root_path
  end

  def display
    
    logger.info "picturesController engaged"
    @picture = Picture.find(:first, :conditions => [ "name = ?", params[:file_name][0]] )
      send_data(
        @picture.data, 
        :type => @picture.content_type,
        :filename => @picture.name,
        :disposition => 'inline'
      )

  end


  def is_own_or_targets_picture?
    @picture = Picture.find(:first, :conditions => [ "name = ?", params[:file_name][0] ])

    if current_user == @picture.user
      return true
    elsif
      current_user.players.each do |player|
        @picture.user.players.each do |pic_player|
          if player.targets.include? pic_player
            return true
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
    end
    logger.info "current user: id=%d" % current_user.id
    redirect_to root_path
    return false
  end

end
