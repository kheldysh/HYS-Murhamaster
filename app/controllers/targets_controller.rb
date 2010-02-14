class TargetsController < ApplicationController

  def show
    @target = Player.find(params[:id])
    @user = @target.user

  end
end
