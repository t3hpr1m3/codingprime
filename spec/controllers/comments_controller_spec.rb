require 'spec_helper'

#describe CommentsController do
#
#  #
#  # INDEX
#  #
#  describe "GET index" do
#    describe "when not logged in" do
#      before( :each ) do
#        @approved_comments = [mock_model( Comment, :approved => true )]
#        @rejected_comments = [mock_model( Comment, :approved => false )]
#        @user = mock_model( User )
#        @post = mock_model( Post, :user => @user )
#        Comment.stub!( :recent ).with( 20, :approved => true ).and_return( @approved_comments )
#        Comment.stub!( :recent ).with( 20, :approved => false ).and_return( @rejected_comments )
#        Post.stub!( :find ).and_return( @post )
#        controller.stub!( :current_user ).and_return( nil )
#        get :index, :post_id => @post.object_id
#      end
#
#      it { should respond_with( :success ) }
#      it { should assign_to( :post ).with( @post ) }
#      it { should assign_to( :approved_comments ).with( @approved_comments ) }
#      it { should_not assign_to( :rejected_comments ) }
#      it { should render_template( :index ) }
#    end
#
#    describe "when logged in" do
#      before( :each ) do
#        @approved_comments = [mock_model( Comment, :approved => true )]
#        @rejected_comments = [mock_model( Comment, :approved => false )]
#        @user = mock_model( User, :is_admin => true )
#        @post = mock_model( Post, :user => @user )
#        Comment.stub!( :recent ).with( 20, :approved => true ).and_return( @approved_comments )
#        Comment.stub!( :recent ).with( 20, :approved => false ).and_return( @rejected_comments )
#        Post.stub!( :find ).and_return( @post )
#        controller.stub!( :current_user ).and_return( @user )
#        get :index, :post_id => @post.object_id
#      end
#
#      it { should respond_with( :success ) }
#      it { should assign_to( :post ).with( @post ) }
#      it { should assign_to( :approved_comments ).with( @approved_comments ) }
#      it { should assign_to( :rejected_comments ).with( @rejected_comments ) }
#      it { should render_template( :index ) }
#    end
#  end
#
#  #
#  # SHOW
#  #
#  describe "GET 'show'" do
#    before( :each ) do
#      @user = mock_model( User )
#      @post = mock_model( Post, :user => @user )
#      @comment = mock_model( Comment, :post => @post )
#      Post.stub!( :find ).and_return( @post )
#      Comment.stub!( :find ).and_return( @comment )
#      get :show, :post_id => @post.object_id, :id => @comment.object_id
#    end
#
#    it { should respond_with( :success ) }
#    it { should assign_to( :post ).with( @post ) }
#    it { should assign_to( :comment ).with( @comment ) }
#    it { should render_template( :show ) }
#  end
#
#  #
#  # NEW
#  #
#  describe "GET 'new'" do
#    before( :each ) do
#      @user = mock_model( User )
#      @post = mock_model( Post, :user => @user )
#      @comment = mock_model( Comment )
#      Post.stub!( :find ).and_return( @post )
#      Comment.stub!( :new ).and_return( @comment )
#      get :new, :post_id => @post.object_id
#    end
#
#    it { should respond_with( :success ) }
#    it { should assign_to( :post ).with( @post ) }
#    it { should assign_to( :comment ).with( @comment ) }
#    it { should render_template( :new ) }
#  end
#
#  #
#  # NEW
#  #
#  describe "POST 'create'" do
#  end
#end
