require "spec_helper"

describe SessionsController do

  before do
    User.create(:username => "paavo", :password => "nurmi")
  end

  it "should authenticate an existing user with correct credentials" do
    post :create, :user => {:username => "paavo", :password => "nurmi"}
    response.should redirect_to(root_path)
  end

  it "should handle username case-insensitively" do
    pending "would require downcase conversion of usernames"
    post :create, :user => {:username => "PAAVO", :password => "nurmi"}
    response.should redirect_to(root_path)
  end

  it "should redirect to login page with wrong credentials" do
    post :create, :user => {:username => "Avpoo", :password => "nurmi"}
    response.should redirect_to(login_path)
  end

end