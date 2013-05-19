require "spec_helper"
require "shared_examples_for_controllers"

describe RingsController do
  it_behaves_like "a referee-restricted CRUD controller", [:create, :update, :destroy, :index, :new, :edit] do
    let(:target_class) { Ring }
  end
end