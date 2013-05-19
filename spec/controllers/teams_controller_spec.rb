require "spec_helper"
require "shared_examples_for_controllers"

describe Tournaments::TeamsController do
  it_behaves_like "a referee-restricted CRUD controller" do
    let(:target_class) { Team }
  end
end