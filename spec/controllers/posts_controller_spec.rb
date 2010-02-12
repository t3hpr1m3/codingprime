require 'spec_helper'

describe PostsController do

	describe "GET 'index'" do

		before( :each ) do
			@post = mock_model( Post )
			@posts = [@post]
			Post.stub!( :find ).and_return( @posts )
		end

		it "should be successful" do
			Post.should_receive( :all ).and_return( @posts )
			get :index
		end

	end

	describe "GET 'show'" do
		before( :each ) do
			@post = mock_model( Post )
			Post.stub!( :find ).and_return( @post )
		end

		it "should be successful" do
			get :show, :id => 1
			response.should be_success
		end

		it "should find the right post" do
			Post.should_receive( :find ).with( "1" ).and_return( @post )
			get :show, :id => "1"
		end

		it "should assign the right post to the view" do
			get :show, :id => "1"
			assigns[:post].should eql( @post )
		end
	end

	describe "GET 'new'" do
		it "should be successful" do
			get 'new'
			response.should be_success
		end
	end

	describe "GET 'edit'" do
		it "should be successful" do
			get 'edit'
			response.should be_success
		end
	end

	describe "GET 'create'" do
		it "should be successful" do
			get 'create'
			response.should be_success
		end
	end

	describe "GET 'update'" do
		it "should be successful" do
			get 'update'
			response.should be_success
		end
	end

	describe "GET 'delete'" do
		it "should be successful" do
			get 'delete'
			response.should be_success
		end
	end
end
