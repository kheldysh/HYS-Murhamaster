require "spec_helper"
require "shared_examples_for_controllers"

describe TargetsController do
  it_behaves_like "a referee-restricted CRUD controller", [:show, :edit, :update] do
    let(:target_class) { Player }
  end
end