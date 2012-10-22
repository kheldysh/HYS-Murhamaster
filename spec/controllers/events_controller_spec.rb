require "spec_helper"

describe EventsController do

  before do
    @tournament = Tournament.create(:start_date => (Date.today - 10), :finish_date => (Date.today + 10))
    @user = User.create(:username => "test", :password => "test")
    Referee.create(:user => @user, :tournament => @tournament)
  end

  it "should let a referee create new events" do
    login(@user)
    get :new, :tournament_id => @tournament
    response.should be_success
  end

  context "when tournament is over" do
    it "should let a referee create new events within 30 days of tournament finishing" do
      @tournament.finish_date = Date.today - 10
      @tournament.save
      login(@user)
      post :create, {:tournament_id => @tournament, :event => {:title => "event", :content => "content"}}
      response.should redirect_to(tournament_events_path(@tournament))
      @tournament.events.last.title.should == "event"
      @tournament.events.last.content.should == "content"
    end

  end
end