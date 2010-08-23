require 'spec_helper'

describe Blog::CommentsController, 'as guest' do
  before( :each ) do
    logout_user
  end

  it { should require_authentication_for( :edit, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :update, :put, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :destroy, :delete, :id => 1, :subdomains => ['blog'] ) }

  describe 'index' do
    before( :each ) do
      @approved_comments = [ Factory( :comment, :approved => true )]
      Comment.stubs( :valid ).returns( @approved_comments )
      Comment.stubs( :rejected ).returns( @rejected_comments )
      get :index, :subdomains => ['blog']
    end

    it { should respond_with( :success ) }
    it { should assign_to( :approved_comments ).with( @approved_comments ) }
    it { should_not assign_to( :rejected_comments ) }
    it { should render_template( :index ) }
  end

  describe 'new' do
    before( :each ) do
      get :new, :subdomains => ['blog']
    end

    it { should set_the_flash }
    it { should redirect_to( blog_root_url ) }
  end

  describe 'create' do
    before( :each ) do
      @post = Factory( :post )
      @comment = Factory.build( :comment, :post => @post )
      @comment.stubs( :save ).returns( true )
      Post.stubs( :find ).returns( @post )
      Comment.stubs( :new ).returns( @comment )
      post :create, :comment => @comment, :subdomains => ['blog']
    end

    describe 'when preview clicked' do
      before( :each ) do
        post :create, :comment => @comment, :preview_button => '1', :subdomains => ['blog']
      end
      it { should assign_to( :preview ) }
      it { should render_template( :new ) }
    end

    describe 'when create clicked' do
      before( :each ) do
        post :create, :comment => @comment, :subdomains => ['blog']
      end
      it { should redirect_to( @post.url ) }
    end
  end
end

describe Blog::CommentsController, "as admin" do
  before( :each ) do
    login_admin
  end

  describe 'index' do
    before( :each ) do
      @approved_comments = [Factory( :comment, :approved => true )]
      @rejected_comments = [Factory( :comment, :approved => false )]
      Comment.stubs( :valid ).returns( @approved_comments )
      Comment.stubs( :rejected ).returns( @rejected_comments )
      get :index, :subdomains => ['blog']
    end

    it { should respond_with( :success ) }
    it { should assign_to( :approved_comments ).with( @approved_comments ) }
    it { should assign_to( :rejected_comments ).with( @rejected_comments ) }
    it { should render_template( :index ) }
  end

  describe 'edit' do
    before( :each ) do
      @comment = Factory( :comment )
      Comment.stubs( :find ).returns( @comment )
      get :edit, :id => @comment.id, :subdomains => ['blog']
    end
    it { should respond_with( :success ) }
    it { should render_template( :edit ) }
  end

  describe 'create' do
    before( :each ) do
      @comment = Factory.build( :comment )
      Comment.stubs( :new ).returns( @comment )
    end

    describe 'when preview clicked' do
      before( :each ) do
        post :create, :comment => @comment.attributes, :preview_button => 'Preview', :subdomains => ['blog']
      end
      it { should respond_with( :success ) }
      it { should render_template( :new ) }
    end

    describe 'when create clicked' do
      describe 'when save fails' do
        before( :each ) do
          @comment.stubs( :save ).returns( false )
          post :create, :comment => @comment.attributes, :subdomains => ['blog']
        end

        it { should set_the_flash }
        it { should render_template( :new ) }
      end
      describe 'when save succeeds' do
        before( :each ) do
          @comment.stubs( :save ).returns( true )
          post :create, :comment => @comment.attributes, :subdomains => ['blog']
        end
        it { should set_the_flash }
        it { should redirect_to( @comment.post.url ) }
      end
    end
  end

  describe 'update' do
    def hit_update
      put :update, :id => @comment.id, :comment => @comment.attributes, :subdomains => ['blog']
    end
    before( :each ) do
      @comment = Factory( :comment )
      Comment.stubs( :find ).returns( @comment )
    end

    describe 'when preview clicked' do
      before( :each ) do
        put :update, :id => @comment.id, :comment => @comment.attributes, :preview => 'Preview', :subdomains => ['blog']
      end
      it { should respond_with( :success ) }
      it { should assign_to( :preview ).with( true ) }
      it { should render_template( :edit ) }
    end

    describe 'when create clicked' do
      describe 'when update_attributes fails' do
        before( :each ) do
          @comment.stubs( :update_attributes ).returns( false )
          hit_update
        end
        it { should set_the_flash }
        it { should render_template( :edit ) }
      end

      describe 'when update_attributes succeeds' do
        before( :each ) do
          @comment.stubs( :update_attributes ).returns( true )
          hit_update
        end
        it { should set_the_flash }
        it { should redirect_to( @comment.post.url ) }
      end
    end
  end

  describe 'delete' do
    before( :each ) do
      @comment = Factory( :comment )
      @comment.stubs( :delete )
      delete :destroy, :id => @comment.id, :subdomains => ['blog']
    end
    it { should redirect_to( @comment.post.url ) }
  end
end


