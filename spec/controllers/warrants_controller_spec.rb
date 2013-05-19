require "spec_helper"
require "shared_examples_for_controllers"

describe WarrantsController do
  let (:target_class) { Warrant }
  it_behaves_like "a referee-restricted CRUD controller", [:create, :update, :destroy, :index, :new, :edit]

  #describe "#index" do
  #  it_behaves_like "a referee-restricted action"
  #end
  #
  #describe "#create" do
  #  it_behaves_like "a referee-restricted action"
  #end
  #
  #describe "#update" do
  #
  #end
  #
  #describe ""
end
