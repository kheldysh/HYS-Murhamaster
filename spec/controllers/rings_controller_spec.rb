require "spec_helper"
require "shared_examples_for_controllers"

describe RingsController do
  it_behaves_like "a referee-restricted CRUD controller", [:create, :update, :destroy, :index, :new, :edit] do
    let(:target_class) { Ring }
  end

  describe '.drop_from_rings' do
    let(:tournament) { Tournament.create }
    let(:player) { Player.create(:tournament => tournament, :alias => "plaa") }
    let(:ring) { Ring.create(:tournament => tournament) }
    let(:hunter) { Player.create(:tournament => tournament, :alias => "hyrk") }
    let(:target) { Player.create(:tournament => tournament, :alias => "gnaa") }

    it "assigns player's target to player's hunter" do
      Assignment.create(:ring => ring, :player => hunter, :target => player)
      Assignment.create(:ring => ring, :player => player, :target => target)
      RingsController.drop_from_rings(player)
      Assignment.count.should == 1
      Assignment.first.player.should == hunter
      Assignment.first.target.should == target
    end

    context 'when player has no targets' do
      it 'removes all assignments with player as target' do
        Assignment.create(:ring => ring, :player => hunter, :target => player)
        Assignment.create(:ring => ring, :player => target, :target => player)
        RingsController.drop_from_rings(player)
        Assignment.count.should == 0
      end
    end

    context 'when player has no hunters' do
      it 'removes all assignments with player as hunter' do
        Assignment.create(:ring => ring, :player => player, :target => hunter)
        Assignment.create(:ring => ring, :player => player, :target => target)
        RingsController.drop_from_rings(player)
        Assignment.count.should == 0
      end
    end
  end
end
