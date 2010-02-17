class CalendarsController < ApplicationController

  before_filter :is_admin?, :except => [:show, :edit, :update, :create]
  before_filter :is_own_calendar?

  def index 
    @calendars = Calendar.find(:all)
  end

  def show
    @calendar = Calendar.find(params[:id])
  end

  def new
    @calendar = Calendar.new
  end

  def edit
    @calendar = Calendar.find(params[:id])
  end

  def create
    @calendar = Calendar.new(params[:calendar])

    respond_to do |format|
      if @calendar.save
        flash[:notice] = 'Calendar was successfully created.'
        format.html { redirect_to(@calendar) }
        format.xml  { render :xml => @calendar, :status => :created, :location => @calendar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @calendar = Calendar.find(params[:id])

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        flash[:notice] = 'Calendar was successfully updated.'
        format.html { redirect_to(@calendar) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @calendar.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to(calendars_url) }
      format.xml  { head :ok }
    end
  end
  
  def is_own_calendar?
    @calendar = Calendar.find(params[:id])
    logger.info "checked if own calendar"
    if (current_user.id == @calendar.user.id) 
      logger.info "is own calendar"
      return true
    elsif current_user.admin
      logger.info "is admin"
      return true
    else
      logger.info "unauthorized"
      redirect_to root_path
      return false
    end
  end
  
end 
