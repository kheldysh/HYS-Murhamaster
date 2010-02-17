class TargetsController < ApplicationController

  before_filter :is_own_target_or_admin?

  def show
    @target = Player.find(params[:id])
    @user = @target.user
    @calendar = @user.calendar

  end
  
  def is_own_target_or_admin?
    if current_user.admin
      return true
    end
    
    @target = Player.find(params[:id])
    current_user.players.each do |player|
      if player.targets.include? @target
        return true
      end
    end
    redirect_to root_path
    return false
  end
end
