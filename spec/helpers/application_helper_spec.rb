require 'spec_helper'

describe ApplicationHelper do

	describe "page_title" do
		describe "with a nil title" do
			it "should be CodingPrime" do
				helper.instance_variable_set '@title', nil
				helper.page_title.should eql( "CodingPrime" )
			end
		end

		describe "with 'Contact' for title" do
			it "should be CodingPrime :: Contact" do
				helper.instance_variable_set '@title', 'Contact'
				helper.page_title.should eql( "CodingPrime :: Contact" )
			end
		end
	end
end
