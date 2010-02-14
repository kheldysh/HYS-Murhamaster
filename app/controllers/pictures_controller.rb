class PicturesController < ApplicationController

  def show
    @picture = Picture.find(params[:id])
    send_data picture.data, :type => picture.content_type, :disposition => 'inline', :filename => picture.name
  end


end
