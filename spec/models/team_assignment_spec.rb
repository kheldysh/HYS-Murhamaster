require "spec_helper"

describe TeamAssignment do
  describe "#assign_targets_to_players" do
    before do
      @team1 = Team.create
      @team2 = Team.create
      @player1 = Player.create(:team => @team1, :status => :active)
      @player2 = Player.create(:team => @team1, :status => :active)
      @player3 = Player.create(:team => @team2, :status => :active)
      @player4 = Player.create(:team => @team2, :status => :active)
    end

    it "assigns targets for individual players" do
      TeamAssignment.create(:team => @team1, :target => @team2)
      @player1.targets.should include(@player3)
      @player1.targets.should include(@player4)
      @player2.targets.should include(@player3)
      @player2.targets.should include(@player4)
    end
  end
end