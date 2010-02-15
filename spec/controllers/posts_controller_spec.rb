require 'spec_helper'

describe PostsController do

	#===============
	#     INDEX
	#===============
	describe "GET 'index'" do
		before( :each ) do
			@post = mock_model( Post )
			@posts = [@post]
			Post.stub!( :find ).and_return( @posts )
		end

		it "should be successful" do
			get :index
			response.should be_success
		end

		it "should get the list of posts" do
			Post.should_receive( :all ).and_return( @posts )
			get :index
		end

		it "should return a single post" do
			get :index
			assigns[:posts].length.should eql( 1 )
		end
	end

	#===============
	#     SHOW
	#===============
	describe "GET 'show'" do
		before( :each ) do
			@post = mock_model( Post, :title => 'Test Post' )
			Post.stub!( :find ).and_return( nil )
			Post.stub!( :find_by_slug ).with( "test-post" ).and_return( @post )
		end

		describe "with a valid id" do
			it "should be successful" do
				get :show, :slug => 'test-post'
				response.should be_success
			end
	
			it "should find the right post" do
				Post.should_receive( :find_by_slug ).with( "test-post" ).and_return( @post )
				get :show, :slug => "test-post"
			end
	
			it "should assign the right post to the view" do
				get :show, :slug => "test-post"
				assigns[:post].should eql( @post )
			end
		end

		describe "with an invalid id" do
			it "should fail with 404" do
				get :show, :slug => "invalid-slug"
				response.should raise_error
			end
		end
	end

	#===============
	#     NEW
	#===============
	describe "GET 'new'" do
		describe "when not logged in" do
			it "should return a 403" do
				lambda { get :new }.should raise_error PermissionDenied
			end
		end

		describe "when logged in" do
			before( :each ) do
				session[:is_admin] = true
				@post = mock_model( Post )
				Post.stub!( :new ).and_return( @post )
			end
	
			it "should be successful" do
				get :new
				response.should be_success
			end
	
			it "should create a new post" do
				Post.should_receive( :new ).and_return( @post )
				get :new
			end
		end
	end 

	#===============
	#     EDIT
	#===============
	describe "GET 'edit'" do

		describe "when not logged in" do
			it "should return a 403" do
				lambda { get :edit, :id => 1 }.should raise_error PermissionDenied
			end
		end

		describe "when logged in" do
			before( :each ) do
				session[:is_admin] = true
				@post = mock_model( Post )
				Post.stub!( :find ).and_return( nil )
				Post.stub!( :find ).with( "1" ).and_return( @post )
			end

			describe "with a valid id" do

				it "should be successful" do
					get :edit, :id => 1
					response.should be_success
				end
		
				it "should find the right post" do
					Post.should_receive( :find ).with( "1" ).and_return( @post )
					get :edit, :id => 1
				end
		
				it "should assign the post to the view" do
					get :edit, :id => "1"
					assigns[:post].should eql( @post )
				end
			end
	
			describe "with an invalid id" do
				it "should fail" do
					get :edit, :id => "2"
					response.should raise_error
				end
			end
		end
	end

	#===============
	#    CREATE
	#===============
	describe "POST 'create'" do
		describe "when not logged in" do
			it "should return a 403" do
				lambda { post :create, :post => { } }.should raise_error PermissionDenied
			end
		end

		describe "when logged in" do
			before( :each ) do
				session[:is_admin] = true
				@post = mock_model( Post )
			end
	
			it "should create a new post" do
				Post.should_receive( :new ).and_return( @post )
				@post.stub!( :save ).and_return( true )
				post :create, :post => { }
			end
	
			it "should save the post" do
				Post.stub!( :new ).and_return( @post )
				@post.should_receive( :save ).and_return( true )
				post :create, :post => { }
			end
		end
	end

	#===============
	#    UPDATE
	#===============
	describe "PUT 'update'" do
		describe "when not logged in" do
			it "should return a 403" do
				lambda { put :update, :id => "1", :post => { } }.should raise_error PermissionDenied
			end
		end

		describe "when logged in" do
			before( :each ) do
				session[:is_admin] = true
				@post = mock_model( Post )
				Post.stub!( :find ).and_return( @post )
				@post.stub!( :update_attributes ).and_return( true )
			end
	
			it "should be successful" do
				put :update, :id => "1", :post => { }
				response.should be_redirect
			end
	
			it "should find the right post" do
				Post.should_receive( :find ).with( "1" ).and_return( @post )
				put :update, :id => "1", :post => {  }
			end
	
			it "should save the post" do
				@post.should_receive( :update_attributes ).and_return( true )
				put :update, :id => "1", :post => { }
			end
		end
	end

	#===============
	#    DELETE
	#===============
	describe "GET 'delete'" do
		describe "when not logged in" do
			it "should return a 403" do
				lambda { delete :destroy, :id => "1" }.should raise_error PermissionDenied
			end
		end

		describe "when logged in" do
			before( :each ) do
				session[:is_admin] = true
				@post = mock_model( Post )
				Post.stub!( :find ).and_return( @post )
				@post.stub!( :delete ).and_return( true )
			end
	
			it "should be successful" do
				delete :destroy, :id => "1"
				response.should be_redirect
			end
	
			it "should find the right post" do
				Post.should_receive( :find ).with( "1" ).and_return( @post )
				delete :destroy, :id => "1"
			end
	
			it "should delete the post" do
				@post.should_receive( :delete ).and_return( true )
				delete :destroy, :id => "1"
			end
		end
	end
end
