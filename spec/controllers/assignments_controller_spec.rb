require "spec_helper"
require "shared_examples_for_controllers"

describe AssignmentsController do
  it_behaves_like "a referee-restricted CRUD controller", [:create, :destroy, :index] do
    let(:target_class) { Assignment }
    let!(:extra_params) { {:ring_id => 1} }
  end
end
