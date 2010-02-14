class TargetsController < ApplicationController

  def show
    @target = Player.find(params[:id])
    @user = @target.user
    @calendar = @user.calendar

  end
end
