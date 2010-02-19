require 'spec_helper'

describe CommentsController do

  def mock_comment(stubs={})
    @mock_comment ||= mock_model(Comment, stubs)
  end

  describe "GET index" do
    describe "when not logged in" do
      before( :each ) do
        controller.should_receive( :current_user ).and_return( nil )
        @approved_comments = [Factory.create( :comment, :approved => true )]
        @rejected_comments = [Factory.create( :comment )]
        get :index
      end

      it { should respond_with( :success ) }
      it { should assign_to( :approved_comments ).with( @approved_comments ) }
      it { should_not assign_to( :rejected_comments ) }
    end
  end
end
