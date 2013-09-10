require 'spec_helper'

describe AdminController do

  describe "GET 'index'" do
    it "not logged in user is rejected" do
      get 'index'
      response.code.should == "302"
      response.should redirect_to(root_path)
    end

    context 'as admin' do
      before(:each) do
        @admin =  FactoryGirl.create(:admin)
        sign_in @admin
      end

      it "get index should succeed" do
        get 'index'
        response.should be_success
      end
    end
  end


end
