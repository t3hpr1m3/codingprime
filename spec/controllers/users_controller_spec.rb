require 'spec_helper'

describe UsersController do
	before( :each ) do
		@user = mock_user
		@users = [@user]
	end

	def mock_user( stubs = {} )
		@mock_user ||= mock_model( User, stubs )
	end

	#===============
	# NOT LOGGED IN
	#===============
	describe "when not logged in" do
		before( :each ) do
			controller.stub( :current_user ).and_return( nil )
			#controller.stub!( :admin? ).and_return( false )
		end

		#
		# INDEX
		#
		describe "GET 'index'" do
			it "should return a 403" do
				lambda { get :index }.should raise_error PermissionDenied
			end
		end

		#
		# SHOW
		#
		describe "GET 'show'" do
			it "should return a 403" do
				lambda { get :show, :id => @user.id }.should raise_error PermissionDenied
			end
		end

		#
		# NEW
		#
		describe "GET 'new'" do
			it "should return a 403" do
				lambda { get :new }.should raise_error PermissionDenied
			end
		end

		#
		# EDIT
		#
		describe "GET 'edit'" do
			it "should return a 403" do
				lambda { get :edit, :id => @user.id }.should raise_error PermissionDenied
			end
		end

		#
		# CREATE
		#
		describe "POST 'create'" do
			it "should return a 403" do
				lambda { post :create, :user => {} }.should raise_error PermissionDenied
			end
		end

		#
		# UPDATE
		#
		describe "PUT 'update'" do
			it "should return a 403" do
				lambda { put :update, :id => @user.id, :user => {} }.should raise_error PermissionDenied
			end
		end

		#
		# DELETE
		#
		describe "DELETE 'delete'" do
			it "should return a 403" do
				lambda { delete :destroy, :id => @user.id }.should raise_error PermissionDenied
			end
		end
	end

	#===============
	# ADMIN LOGIN
	#===============
	describe "when logged in as an admin" do
		before( :each ) do
			controller.stub( :current_user ).and_return( Factory.create( :admin ) )
		end

		#
		# INDEX
		#
		describe "GET 'index'" do
			before( :each ) do
				User.should_receive( :all ).and_return( @users )
				get :index
			end

			it { should respond_with( :success ) }
			it { should assign_to( :users ).with( @users ) }
		end

		#
		# SHOW
		#
		describe "GET 'show'" do
			describe "with a valid id" do
				before( :each ) do
					User.should_receive( :find ).with( @user.id.to_s ).and_return( @user )
					get :show, :id => @user.id
				end

				it { should respond_with( :success ) }
				it { should assign_to( :user ).with( @user ) }
			end

			describe "with an invalid id" do
				it "should fail with 404" do
					User.should_receive( :find ).with( "1000" ).and_raise( ActiveRecord::RecordNotFound )
					lambda { get :show, :id => 1000 }.should raise_error ActiveRecord::RecordNotFound
				end
			end
		end

		#
		# NEW
		#
		describe "GET 'new'" do
			before( :each ) do
				User.should_receive( :new ).and_return( @user )
				get :new
			end

			it { should respond_with( :success ) }
			it { should assign_to( :user ).with( @user ) }
		end

		#
		# EDIT
		#
		describe "GET 'edit'" do
			describe "with a valid id" do
				before( :each ) do
					User.should_receive( :find ).with( @user.id.to_s ).and_return( @user )
					get :edit, :id => @user.id
				end

				it { should respond_with( :success ) }
				it { should assign_to( :user ).with( @user ) }
			end

			describe "with an invalid id" do
				it "should fail" do
					User.should_receive( :find ).with( ( @user.id + 1 ).to_s ).and_raise( ActiveRecord::RecordNotFound )
					lambda { get :edit, :id => @user.id + 1 }.should raise_error ActiveRecord::RecordNotFound
				end
			end
		end

		#
		# CREATE
		#
		describe "POST 'create'" do
			before( :each ) do
				User.should_receive( :new ).and_return( @user )
				@user.stub!( :save ).and_return( true )
				post :create, :user => {}
			end

			it { should redirect_to( user_url( @user ) ) }
		end
	end
#
#	describe "POST create" do
#
#		describe "with valid params" do
#			it "assigns a newly created user as @user" do
#				User.stub(:new).with({'these' => 'params'}).and_return(mock_user(:save => true))
#				post :create, :user => {:these => 'params'}
#				assigns[:user].should equal(mock_user)
#			end
#
#			it "redirects to the created user" do
#				User.stub(:new).and_return(mock_user(:save => true))
#				post :create, :user => {}
#				response.should redirect_to(user_url(mock_user))
#			end
#		end
#
#		describe "with invalid params" do
#			it "assigns a newly created but unsaved user as @user" do
#				User.stub(:new).with({'these' => 'params'}).and_return(mock_user(:save => false))
#				post :create, :user => {:these => 'params'}
#				assigns[:user].should equal(mock_user)
#			end
#
#			it "re-renders the 'new' template" do
#				User.stub(:new).and_return(mock_user(:save => false))
#				post :create, :user => {}
#				response.should render_template('new')
#			end
#		end
#
#	end
#
#	describe "PUT update" do
#
#		describe "with valid params" do
#			it "updates the requested user" do
#				User.should_receive(:find).with("37").and_return(mock_user)
#				mock_user.should_receive(:update_attributes).with({'these' => 'params'})
#				put :update, :id => "37", :user => {:these => 'params'}
#			end
#
#			it "assigns the requested user as @user" do
#				User.stub(:find).and_return(mock_user(:update_attributes => true))
#				put :update, :id => "1"
#				assigns[:user].should equal(mock_user)
#			end
#
#			it "redirects to the user" do
#				User.stub(:find).and_return(mock_user(:update_attributes => true))
#				put :update, :id => "1"
#				response.should redirect_to(user_url(mock_user))
#			end
#		end
#
#		describe "with invalid params" do
#			it "updates the requested user" do
#				User.should_receive(:find).with("37").and_return(mock_user)
#				mock_user.should_receive(:update_attributes).with({'these' => 'params'})
#				put :update, :id => "37", :user => {:these => 'params'}
#			end
#
#			it "assigns the user as @user" do
#				User.stub(:find).and_return(mock_user(:update_attributes => false))
#				put :update, :id => "1"
#				assigns[:user].should equal(mock_user)
#			end
#
#			it "re-renders the 'edit' template" do
#				User.stub(:find).and_return(mock_user(:update_attributes => false))
#				put :update, :id => "1"
#				response.should render_template('edit')
#			end
#		end
#
#	end
#
#	describe "DELETE destroy" do
#		it "destroys the requested user" do
#			User.should_receive(:find).with("37").and_return(mock_user)
#			mock_user.should_receive(:destroy)
#			delete :destroy, :id => "37"
#		end
#
#		it "redirects to the users list" do
#			User.stub(:find).and_return(mock_user(:destroy => true))
#			delete :destroy, :id => "1"
#			response.should redirect_to(users_url)
#		end
#	end
end
