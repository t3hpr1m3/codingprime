require 'spec_helper'

describe Blog::CommentsController do
  before( :each ) do
    logout_user
  end

  #
  # INDEX
  #
  describe "GET index" do
    before( :each ) do
      @approved_comments = [stub( :approved => true )]
      @rejected_comments = [stub( :approved => false )]
      Comment.stubs( :recent ).with( 20, :approved => true ).returns( @approved_comments )
      Comment.stubs( :recent ).with( 20, :approved => false ).returns( @rejected_comments )
    end

    describe "when not logged in" do
      before( :each ) do
        get :index, {:subdomains => ["blog"]}
      end

      it { should respond_with( :success ) }
      it { should assign_to( :approved_comments ).with( @approved_comments ) }
      it { should_not assign_to( :rejected_comments ) }
      it { should render_template( :index ) }
    end

    describe "when logged in as admin" do
      before( :each ) do
        login_admin
        get :index, {:subdomains => ["blog"]}
      end

      it { should respond_with( :success ) }
      it { should assign_to( :approved_comments ).with( @approved_comments ) }
      it { should assign_to( :rejected_comments ).with( @rejected_comments ) }
      it { should render_template( :index ) }
    end
  end

  #
  # SHOW
  #
  describe "GET 'show'" do
    before( :each ) do
      @post = stub()
      @comment = stub()
      Post.stubs( :find ).returns( @post )
      Comment.stubs( :find ).returns( @comment )
      get :show, { :post_id => 1, :id => 1, :subdomains => ["blog"] }
    end

    it { should respond_with( :success ) }
    it { should assign_to( :post ).with( @post ) }
    it { should assign_to( :comment ).with( @comment ) }
    it { should render_template( :show ) }
  end

  #
  # NEW
  #
  describe "GET 'new'" do
    before( :each ) do
      @post = stub()
      @comment = stub()
      Post.stubs( :find ).returns( @post )
      Comment.stubs( :new ).returns( @comment )
      get :new, { :post_id => 1, :subdomains => ["blog"] }
    end

    it { should respond_with( :success ) }
    it { should assign_to( :post ).with( @post ) }
    it { should assign_to( :comment ).with( @comment ) }
    it { should render_template( :new ) }
  end

#  #
#  # NEW
#  #
#  describe "POST 'create'" do
#  end
end
