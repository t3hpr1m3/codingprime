require 'spec_helper'

describe SessionsController do

	#Delete these examples and add some real ones
	it "should use SessionsController" do
		controller.should be_an_instance_of(SessionsController)
	end


	describe "GET 'create'" do
		it "should be successful" do
			get 'create'
			response.should be_redirect
		end
	end

	describe "GET 'destroy'" do
		it "should be successful" do
			get 'destroy'
			response.should be_redirect
		end
	end
end
