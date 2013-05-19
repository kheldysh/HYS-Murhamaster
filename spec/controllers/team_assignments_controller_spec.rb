require "spec_helper"
require "shared_examples_for_controllers"

describe TeamAssignmentsController do
  it_behaves_like "a referee-restricted CRUD controller", [:create, :destroy, :index] do
    let(:target_class) { TeamAssignment }
  end
end