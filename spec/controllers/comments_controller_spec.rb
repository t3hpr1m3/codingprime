require 'spec_helper'

describe CommentsController do

  def mock_comment(stubs={})
    @mock_comment ||= mock_model(Comment, stubs)
  end

  describe "GET index" do
    describe "when not logged in" do
      before( :each ) do
        controller.should_receive( :current_user ).and_return( nil )
        @approved_comments = [Factory.build( :comment, :approved => true )]
        Comment.should_receive( :recent ).with( 20, :approved => true ).and_return( @approved_comments )
        Comment.should_not_receive( :recent ).with( 20, :approved => false )
        get :index, :post_id => 1
      end

      it { should respond_with( :success ) }
      it { should assign_to( :approved_comments ).with( @approved_comments ) }
      it { should_not assign_to( :rejected_comments ) }
    end
  end
end
