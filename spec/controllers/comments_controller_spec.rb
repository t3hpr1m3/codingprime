require 'spec_helper'

#describe CommentsController do
#
#  #
#  # INDEX
#  #
#  describe "GET index" do
#    describe "when not logged in" do
#      before( :all ) do
#        @approved_comments = [mock_model( Comment, :approved => true )]
#        @rejected_comments = [mock_model( Comment, :approved => false )]
#        @post = Factory.create( :post )
#      end
#
#      before( :each ) do
#        Comment.stub!( :recent ).with( 20, :approved => true ).and_return( @approved_comments )
#        Comment.stub!( :recent ).with( 20, :approved => false ).and_return( @rejected_comments )
#        Post.stub!( :find ).and_return( @post )
#        controller.stub!( :admin? ).and_return( false )
#        get :index, :post_id => @post.id
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
#      before( :all ) do
#        @approved_comments = [mock_model( Comment, :approved => true )]
#        @rejected_comments = [mock_model( Comment, :approved => false )]
#        @post = Factory.create( :post )
#      end
#
#      before( :each ) do
#        Comment.stub!( :recent ).with( 20, :approved => true ).and_return( @approved_comments )
#        Comment.stub!( :recent ).with( 20, :approved => false ).and_return( @rejected_comments )
#        Post.stub!( :find ).and_return( @post )
#        controller.stub!( :admin? ).and_return( true )
#        get :index, :post_id => @post.id
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
#    before( :all ) do
#      @post = Factory.create( :post )
#      @comment = Factory.create( :comment, :post => @post )
#    end
#    before( :each ) do
#      get :show, :post_id => @post.id, :id => @comment.id
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
#      @post = Factory.create( :post )
#      get :new, :post_id => @post.id
#    end
#
#    it { should respond_with( :success ) }
#    it { should assign_to( :post ).with( @post ) }
#    it { should render_template( :new ) }
#  end
#
#  #
#  # NEW
#  #
#  describe "POST 'create'" do
#  end
#end
