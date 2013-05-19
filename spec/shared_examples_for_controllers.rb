require "spec_helper"

shared_examples "a referee-restricted action" do |action, http_method|
  let!(:user) { login }
  let!(:referee) { Referee.create(:user => user)}
  let(:correct_tournament) { Tournament.create(:start_date => (Date.today - 10), :finish_date => (Date.today + 10)) }
  let(:wrong_tournament) { Tournament.create(:start_date => (Date.today - 10), :finish_date => (Date.today + 10)) }
  let(:target_id) { target_class.create.id }
  let(:base_params) { {:tournament_id => correct_tournament.id, :id => target_id} }
  let(:params) { defined?(extra_params) ? base_params.merge(extra_params) : base_params }

  it "accepts a referee of the tournament in hand" do
    referee.update_attribute(:tournament, correct_tournament)
    send(http_method, action, params)
    response.should_not redirect_to(root_path)
  end

  it "denies a referee for a different tournament" do
    referee.update_attribute(:tournament, wrong_tournament)
    send(http_method, action, params)
    response.should redirect_to(root_path)
  end

  it "denies a normal user" do
    referee.delete
    send(http_method, action, params)
    response.should redirect_to(root_path)
  end
end

shared_examples "a referee-restricted CRUD controller" do |actions|
  actions ||= [:create, :update, :destroy, :index, :show, :new]
  context "with following actions" do
    actions.each do |action|
      describe "##{action}" do
        it_behaves_like "a referee-restricted action", action, http_method_for(action)
      end
    end
  end
end

def http_method_for(controller_method)
  crud_map = {
      :create => :post,
      :update => :put,
      :destroy => :delete,
      :new => :get,
      :edit => :get,
      :index => :get,
      :show => :get
  }
  crud_map[controller_method]
end
