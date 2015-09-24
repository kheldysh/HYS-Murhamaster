require 'spec_helper'
require 'shared_examples_for_controllers'

describe IlmosController do

  describe '#index' do
    it_behaves_like 'a referee-restricted action', :index, :get do
      let(:target_id) { nil }
    end
  end

  describe '#create' do
    context 'with unauthenticated user' do
      before do
        @tournament = Tournament.create
      end
      it 'accepts name and alias with nordic characters' do
        post :create, {
                        player: {alias: 'fåå'},
                        user: {
                            first_name: 'sössö',
                            last_name: 'räikkälä',
                        },
                        tournament_id: @tournament.id}
        u = User.first
        u.first_name.should == 'sössö'
        u.last_name.should == 'räikkälä'
        Player.first.alias.should == 'föö'
      end
    end

    context 'with authenticated user' do
      before do
        @user = login
        @tournament = Tournament.create
      end

      it 'accepts registration with alias' do
        post :create, {player: {alias: 'foo'}, tournament_id: @tournament.id}
        response.should be_success
        Player.find_by_tournament_id_and_alias(@tournament.id, 'foo').should_not be_nil
      end
      
      context 'with team game' do
        before do
          @user = login
          @tournament = Tournament.create(team_game: true)
        end
        it 'accepts registration with alias and team name' do
          post :create, {player: {alias: 'foo'}, team: {name: 'bar'}, tournament_id: @tournament.id}
          response.should be_success
          player = Player.find_by_tournament_id_and_alias(@tournament.id, 'foo')
          team = Team.find_by_tournament_id_and_name(@tournament.id, 'bar')
          player.should_not be_nil
          team.should_not be_nil
          player.team.should == team
        end
      end
    end
  end
end