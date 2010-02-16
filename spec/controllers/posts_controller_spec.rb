require 'spec_helper'

describe PostsController do
	before( :each ) do
		@post = Factory.create( :post )
	end

	#===============
	# NOT LOGGED IN
	#===============
	describe "when not logged in" do

		#
		# INDEX
		#
		describe "GET 'index'" do
			before( :each ) do
				@posts = [@post]
				Post.stub!( :find ).with( :all ).and_return( @posts )
				get :index
			end

			it { should respond_with( :success ) }
			it { should assign_to( :posts ).with( @posts ) }
		end

		#
		# SHOW
		#
		describe "GET 'show'" do
			describe "with a valid id" do
				before( :each ) do
					Post.stub( :find_by_slug ).with( @post.slug ).and_return( @post )
					get :show, :slug => @post.slug
				end

				it { should respond_with( :success ) }
				it { should assign_to( :post ).with( @post ) }
			end

			describe "with an invalid id" do

				it "should fail with 404" do
					Post.stub( :find_by_slug ).and_return( nil )
					lambda { get :show, :slug => "invalid-slug" }.should raise_error ActiveRecord::RecordNotFound
				end
			end
		end

		#
		# NEW
		#
		describe "GET 'new'" do
			it "should raise a 403" do
				lambda { get :new }.should raise_error PermissionDenied
			end
		end

		#
		# EDIT
		#
		describe "GET 'edit'" do
			it "should raise a 403" do
				lambda { get :edit }.should raise_error PermissionDenied
			end
		end

		#
		# CREATE
		#
		describe "POST 'create'" do
			it "should raise a 403" do
				lambda { post :create, :post => { } }.should raise_error PermissionDenied
			end
		end

		#
		# UPDATE
		#
		describe "PUT 'update'" do
			it "should raise a 403" do
				lambda { put :update, :id => "1", :post => { } }.should raise_error PermissionDenied
			end
		end

		#
		# DELETE
		#
		describe "DELETE 'delete'" do
			it "should raise a 403" do
				lambda { delete :destroy, :id => "1" }.should raise_error PermissionDenied
			end
		end
	end

	#===============
	# ADMIN LOGIN
	#===============
	describe "when logged in as an admin" do
		before( :each ) do
			controller.stub!( :admin? ).and_return( true )
		end

		#
		# NEW
		#
		describe "GET 'new'" do
			before( :each ) do
				Post.should_receive( :new ).and_return( @post )
				get :new
			end

			it { should respond_with( :success ) }
			it { should assign_to( :post ).with( @post ) }
		end

		#
		# EDIT
		#
		describe "GET 'edit'" do
			describe "with a valid id" do
				before( :each ) do
					Post.should_receive( :find ).with( @post.id.to_s ).and_return( @post )
					get :edit, :id => @post.id
				end

				it { should respond_with( :success ) }
				it { should assign_to( :post ).with( @post ) }
			end
	
			describe "with an invalid id" do
				it "should fail" do
					Post.should_receive( :find ).with( ( @post.id + 1 ).to_s ).and_raise( ActiveRecord::RecordNotFound )
					lambda { get :edit, :id => @post.id + 1 }.should raise_error ActiveRecord::RecordNotFound
				end
			end
		end

		#
		# CREATE
		#
		describe "POST 'create'" do
			before( :each ) do
				Post.should_receive( :new ).and_return( @post )
				@post.stub!( :save ).and_return( true )
				post :create, :post => {}
			end

			it { should redirect_to( post_url( @post ) ) }
		end

		#
		# UPDATE
		#
		describe "PUT 'update'" do
			describe "with a valid id" do
				before( :each ) do
					@post.should_receive( :update_attributes ).with( {} ).and_return( true )
					Post.should_receive( :find ).with( @post.id.to_s ).and_return( @post )
					put :update, :id => @post.id, :post => {}
				end

				it { should redirect_to( post_url( @post ) ) }
			end

			describe "with an invalid id" do
				before( :each ) do
				end

				it "should fail" do
					Post.should_receive( :find ).with( ( @post.id + 1 ).to_s ).and_raise( ActiveRecord::RecordNotFound )
					lambda { put :update, :id => @post.id + 1, :post => {} }.should raise_error ActiveRecord::RecordNotFound
				end
			end
		end

		#
		# DELETE
		#
		describe "delete 'DELETE'" do
			describe "with a valid id" do
				before( :each ) do
					Post.stub( :find ).with( @post.id.to_s ).and_return( @post )
					@post.should_receive( :delete ).and_return( true )
					delete :destroy, :id => @post.id
				end

				it { should redirect_to( posts_url ) }
			end

			describe "with an invalid id" do
				it "should fail" do
					Post.should_receive( :find ).with( ( @post.id + 1 ).to_s ).and_raise( ActiveRecord::RecordNotFound )
					lambda { delete :destroy, :id => @post.id + 1, :post => {} }.should raise_error ActiveRecord::RecordNotFound
				end
			end
		end
	end
end
