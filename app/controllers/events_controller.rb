class EventsController < ApplicationController
  before_filter :is_referee, :except => [:index]
  layout "events", :except => [:new, :edit]
  def index 
    @tournament = Tournament.find(params[:tournament_id])
    @events = @tournament.events.sort_by {|e| e.time}    
    @is_referee = is_referee?
  end

  def show
    @tournament = Tournament.find(params[:tournament_id])
    
    @event = Event.find(params[:id])
  end

  def new
    @tournament = Tournament.find(params[:tournament_id])
    @event = Event.new
    render :layout => "application"
  end

  def edit
    @tournament = Tournament.find(params[:tournament_id])
    @event = Event.find(params[:id])
    render :layout => "application"
  end

  def create
    @tournament = Tournament.find(params[:tournament_id])
    @event = Event.new(params[:event])
    @event.tournament = @tournament
    @event.save!
    Tournament.update_stats(@tournament)    
    redirect_to tournament_events_path(@tournament)
  end

  def update
    @tournament = Tournament.find(params[:tournament_id])
    @event = Event.find(params[:id])
    @event.update_attributes(params[:event])
    Tournament.update_stats(@tournament)    
    flash[:notice] = 'Event was successfully updated.'
    redirect_to tournament_events_path(@tournament)
  end


  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

end
