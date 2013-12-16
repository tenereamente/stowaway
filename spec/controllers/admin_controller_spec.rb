require 'spec_helper'

# module StoreFrontend
#   describe HomeController do

#     describe "GET 'index'" do
#       it "returns http success" do
#         get 'index', use_route: 'store_frontend' # in my case
#         response.should be_success
#       end
# module RailsAdmin

describe AdminController do

  describe "GET 'index'" do
    it "not logged in user is rejected" do
      get 'index', use_route: 'rails_admin'
      response.code.should == "302"
      response.should redirect_to(root_path)
    end

    context 'as admin' do
      before(:each) do
        @admin =  FactoryGirl.create(:admin)
        sign_in @admin
      end

      it "get index should succeed" do
        get 'index', use_route: 'rails_admin'
        response.should be_success
      end
    end
  end


end
