class SpecialTournamentsController < ApplicationController

  before_filter :is_referee?, :except => [:new, :create]
  before_filter :is_admin?, :only => [:new, :create]

  def show
    @tournament = Tournament.find(params[:id])
    @players = @tournament.players.sort { |a,b| a.user.last_name <=> b.user.last_name }
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(params[:tournament])

    if @tournament.save
      flash[:notice] = 'Tournament was successfully created.'
      redirect_to(@tournament)
    else
      render :action => "new"
    end
  end

  def update
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        flash[:notice] = 'Tournament was successfully updated.'
        redirect_to(@tournament)
      else
        render :action => "edit"
      end
    end
  end

  def is_referee?
    return true if current_user.admin
    tournament = Tournament.find(params[:id])
    tournament.referees.each do |ref|
      if current_user.referees.include?(ref)
        return true
      end
    end
    redirect_to root_path
  end

end
