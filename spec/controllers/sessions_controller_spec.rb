require 'spec_helper'

describe SessionsController do
  describe "GET 'new'" do
    describe "while logged in" do
      before( :each ) do
        @user = Factory.create( :user )
        controller.should_receive( :current_user ).and_return( @user )
        get :new
      end

      it { should set_the_flash }
      it { should redirect_to( root_url ) }
    end

    describe "while not logged in" do
      before( :each ) do
        controller.should_receive( :current_user ).and_return( nil )
        get :new
      end
  
      it { should respond_with( :success ) }
      it { should render_template( :new ) }
    end
  end

  describe "POST 'create'" do
    describe "with a valid username/password" do
      before( :each ) do
        @user = Factory.create( :user )
        User.should_receive( :authenticate ).with( @user.username, @user.password ).and_return( @user )
        post :create, :username => @user.username, :password => @user.password
      end
  
      it { should redirect_to root_path }
      it { should set_session( :user_id ).to( @user.id ) }
      it { should set_the_flash.to( { :notice => "Login Successful" } ) }
    end

    describe "with an invalid username/password" do
      before( :each ) do
        @user = Factory.create( :user )
        User.should_receive( :authenticate ).with( @user.username, @user.password ).and_return( nil )
        post :create, :username => @user.username, :password => @user.password
      end

      it { should redirect_to login_path }
      it { should set_the_flash.to( { :notice => "Invalid username/password" } ) }
    end
  end

  describe "DELETE 'delete'" do
    describe "while logged in" do
      before( :each ) do
        @user = Factory.create( :user )
        controller.should_receive( :current_user ).and_return( @user )
        delete :destroy
      end
  
      it { should redirect_to root_path }
      it { should set_the_flash }
      it { should set_session( :user_id ).to( nil ) }
    end

    describe "while not logged in" do
      before( :each ) do
        controller.should_receive( :current_user ).and_return( nil )
        delete :destroy
      end

      it { should redirect_to root_path }
      it { should_not set_session( :user_id ) }
    end
  end
end
