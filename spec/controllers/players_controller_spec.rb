require "spec_helper"
require "shared_examples_for_controllers"

describe PlayersController do
  it_behaves_like "a referee-restricted CRUD controller", [:index, :show, :update, :destroy, :edit] do
    let(:target_class) { Player }
  end
end