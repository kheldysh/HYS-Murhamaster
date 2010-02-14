class PicturesController < ApplicationController

  def edit
    @picture = Picture.find(:first, :conditions => ["user_id = ?", params[:user_id]])
    @user = User.find(params[:user_id])
  end

  def update
    @picture = Picture.find(params[:id])
    
  end

  def display
    logger.info "picturesController engaged"
    @picture = Picture.find(:first, :conditions => [ "name = ?", params[:file_name][1]] )
      send_data(
        @picture.data, 
        :type => @picture.content_type,
        :filename => @picture.name,
        :disposition => 'inline'
      )

  end


end
