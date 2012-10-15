class TournamentsController < ApplicationController

  before_filter :is_referee?, :except => [:ilmo, :edit, :update, :index]
  before_filter :is_admin?, :only => [:edit, :update, :index]


  def ilmo
    @tournament = Tournament.find(params[:id])
    @user = User.new
    @player = Player.new
    @calendar = Calendar.new
  end

  def index
    flash.keep
    @tournaments = Tournament.find(:all)
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def new
    @tournament = Tournament.new
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def create
    @tournament = Tournament.new(params[:tournament])

    respond_to do |format|
      if @tournament.save
        # ensure all statistics to be zero
        Tournament.update_stats(@tournament)

        flash[:notice] = 'Tournament was successfully created.'
        format.html { redirect_to(@tournament) }
        format.xml  { render :xml => @tournament, :status => :created, :location => @tournament }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tournament.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        flash[:notice] = 'Tournament was successfully updated.'
        format.html { redirect_to(@tournament) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tournament.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy
  end


  def is_referee?
    if current_user.admin
      return true
    else
      tournament = Tournament.find(params[:id])
      tournament.referees.each do |ref|
        if current_user.referees.include?(ref)
          return true
        end
      end
    end
    redirect_to root_path
  end

end