require "spec_helper"

describe IlmosController do

  describe "#create" do

    context "with authenticated user" do

      before do
        @user = login
        @tournament = Tournament.create
      end

      it "accepts registration with alias" do
        post :create, { :player => { :alias => "foo" }, :tournament_id => @tournament.id }
        response.should redirect_to(root_path)
        Player.find_by_tournament_id_and_alias(@tournament.id, "foo").should_not be_nil
      end

      context "with team game" do
        before do
          @user = login
          @tournament = Tournament.create(:team_game => true)
        end
        it "accepts registration with alias and team name" do
          post :create, { :player => { :alias => "foo" }, :team => { :name => "bar" }, :tournament_id => @tournament.id }
          response.should redirect_to(root_path)
          player = Player.find_by_tournament_id_and_alias(@tournament.id, "foo")
          team = Team.find_by_tournament_id_and_name(@tournament.id, "bar")
          player.should_not be_nil
          team.should_not be_nil
          player.team.should == team
        end
      end
    end
  end
end