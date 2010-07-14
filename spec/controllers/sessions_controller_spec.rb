require 'spec_helper'

describe SessionsController do
  before( :each ) do
    logout_user
  end
  describe "GET 'new'" do
    describe "while logged in" do
      before( :each ) do
        login_user
        get :new
      end

      it { should set_the_flash }
      it { should redirect_to( root_url ) }
    end

    describe "while not logged in" do
      before( :each ) do
        get :new
      end
  
      it { should respond_with( :success ) }
      it { should render_template( :new ) }
    end
  end

  describe "POST 'create'" do
    describe "with a valid username/password" do
      before( :each ) do
        @user = stub( :id => 1 )
        User.stubs( :authenticate ).returns( @user )
        post :create, :username => 'test', :password => 'password'
      end
  
      it { should redirect_to root_path }
      it { should set_session( :user_id ).to( @user.id ) }
      it { should set_the_flash.to( { :notice => "Login Successful" } ) }
    end

    describe "with an invalid username/password" do
      before( :each ) do
        User.stubs( :authenticate ).returns( nil )
        post :create, :username => 'test', :password => 'badpassword'
      end

      it { should redirect_to login_path }
      it { should set_the_flash.to( { :notice => "Invalid username/password" } ) }
    end
  end

  describe "DELETE 'delete'" do
    describe "while logged in" do
      before( :each ) do
        login_user
        delete :destroy
      end
  
      it { should redirect_to root_path }
      it { should set_the_flash }
      it { should set_session( :user_id ).to( nil ) }
    end

    describe "while not logged in" do
      before( :each ) do
        delete :destroy
      end

      it { should redirect_to root_path }
      it { should_not set_session( :user_id ) }
    end
  end
end
