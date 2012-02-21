require 'spec_helper'

describe SessionsController do
  before { logout_user }

  describe "GET 'new'" do
    context 'while logged in' do
      before {
        login_user
        get :new
      }

      it { should redirect_to root_url(:subdomain => @request.subdomain) }
      specify { flash[:alert].should eql('Already logged in.  Please log out first.') }
    end

    describe "while not logged in" do
      before { get :new }
  
      it { should respond_with(:success) }
      it { should render_template(:new) }
    end
  end

  describe "POST 'create'" do

    context 'with an invalid username/password' do
      before {
        User.stubs(:authenticate).returns( nil )
        post :create
      }

      it { should redirect_to login_url(:subdomain => @request.subdomain) }
      specify { flash[:alert].should eql('Invalid Username/Password') }
    end

    context 'with a valid username/password' do
      let(:user) { stub(:id => 1) }
      before {
        User.stubs(:authenticate).returns(user)
        post :create
      }
  
      it { should redirect_to root_url(:subdomain => @request.subdomain) }
      it { should set_session(:user_id).to(user.id) }
      specify { flash[:notice].should eql('Login Successful') }
    end
  end

  describe "DELETE 'destroy'" do
    context 'while logged in' do
      before {
        login_user
        delete :destroy
      }
  
      it { should redirect_to root_url(:subdomain => @request.subdomain) }
      it { should set_the_flash }
      it { should set_session(:user_id).to(nil) }
    end

    context 'while not logged in' do
      before { delete :destroy }

      it { should redirect_to root_url(:subdomain => @request.subdomain) }
      it { should_not set_session(:user_id) }
    end
  end
end
