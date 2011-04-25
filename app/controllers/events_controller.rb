class EventsController < ApplicationController
  def index 
    @tournament = Tournament.find(params[:tournament_id])
    logger.info(@tournament)
    @events = @tournament.events.sort_by {|e| e.time}
    logger.info(@events.first.title)
    
  end

  def show
    @tournament = Tournament.find(params[:tournament_id])
    
    @event = Event.find(params[:id])
  end

  def new
    @tournament = Tournament.find(params[:tournament_id])
    @event = Event.new
  end

  def edit
    @tournament = Tournament.find(params[:tournament_id])
    @event = Event.find(params[:id])
  end

  def create
    @tournament = Tournament.find(params[:tournament_id])
    @event = Event.new(params[:event])
    @event.tournament = @tournament
    @event.save!
    
    redirect_to tournament_events_path(@tournament)
  end

  def update
    @tournament = Tournament.find(params[:tournament_id])
    @event = Event.find(params[:id])
    @event.update_attributes(params[:event])
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
