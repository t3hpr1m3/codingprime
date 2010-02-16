require 'spec_helper'

describe SessionsController do
	describe "GET 'new'" do
		before( :each ) do
			get :new
		end

		it { should respond_with( :success ) }
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
end
