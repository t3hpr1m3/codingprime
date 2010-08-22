require 'spec_helper'

describe Blog::PostsController, 'as guest' do
  before( :each ) do
    logout_user
  end

  describe 'index' do
    before( :each ) do
      @paginated = mock( 'paginated_posts' )
      @posts = mock( 'posts' )
      @posts.stubs( :paginate ).returns( @paginated )
      Post.stubs( :recent ).returns( @posts )
      get :index, {:subdomains => ["blog"]}
    end

    it { should respond_with( :success ) }
    it { should assign_to( :posts ).with( @patinated ) }
    it { should render_template( :index ) }
  end

  describe 'show' do
    describe 'with a valid id' do
      before( :each ) do
        @post = Factory.create( :post )
        Post.stubs( :find ).returns( @post )
        get :show, :id => 1, :subdomains => ["blog"]
      end

      it { should redirect_to( @request.protocol + @request.host + @post.url ) }
    end
  end

  describe 'show_by_slug' do
    describe 'with a valid slug' do
      before( :each ) do
        @post = Factory.create( :post )
        Post.stubs( :find_by_slug ).returns( @post )
        get :show_by_slug , :year => 2010, :month => 02, :day => 01, :slug => 'test-title', :subdomains => ['blog']
      end

      it { should respond_with( :success ) }
      it { should assign_to( :post ).with( @post ) }
      it { should assign_to( :comment ).with_kind_of( Comment ) }
      it { should render_template( :show ) }
    end

    describe 'with an invalid slug' do
      it 'should fail with 404' do
        Post.stubs( :find_by_slug ).returns( nil )
        lambda { get :show_by_slug, :year => 2010, :month => 02, :day => 01, :slug => 'invalid-slug', :subdomains => ['blog'] }.should raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  it { should require_authentication_for( :get, :new, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :get, :edit, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :post, :create, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :put, :update, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :delete, :destroy, :id => 1, :subdomains => ['blog'] ) }
end

describe Blog::PostsController, 'as admin' do
  before( :each ) do
    login_admin
  end

  describe 'new' do
    before( :each ) do
      @post = Post.new
      Post.stubs( :new ).returns( @post )
      get :new, :subdomains => ['blog']
    end

    it { should respond_with( :success ) }
    it { should assign_to( :post ).with( @post ) }
    it { should render_template( :new ) }
  end

  describe 'edit' do
    before( :each ) do
      @post = Factory.create( :post )
    end

    describe 'with a valid id' do
      before( :each ) do
        Post.stubs( :find ).returns( @post )
        get :edit, :id => @post.id, :subdomains => ['blog']
      end

      it { should respond_with( :success ) }
      it { should assign_to( :post ).with( @post ) }
      it { should render_template( :edit ) }
    end

    describe 'with an invalid id' do
      it "should fail" do
        Post.stubs( :find ).raises( ActiveRecord::RecordNotFound )
        lambda { get :edit, :id => 1, :subdomains => ['blog'] }.should raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'create' do
    describe 'when preview clicked' do
      before( :each ) do
        post :create, :preview_button => 'Preview', :post => {}, :subdomains => ['blog']
      end

      it { should respond_with( :success ) }
      it { should assign_to( :post ).with_kind_of( Post ) }
      it { should assign_to( :preview ).with( true ) }
      it { should render_template( :new ) }
    end

    describe 'when submit clicked' do
      describe 'and save is successful' do
        before( :each ) do
          @post = Factory.build( :post )
          Post.stubs( :new ).returns( @post )
          post :create, :post => {}, :subdomains => ['blog']
        end

        it { should redirect_to( @post.url ) }
        it { should set_the_flash }
      end

      describe 'and save fails' do
        before( :each ) do
          @post = Factory.build( :post )
          @post.stubs( :save ).returns( false )
          post :create, :post => {}, :subdomains => ['blog']
        end

        it { should set_the_flash }
        it { response.should render_template( :new ) } 
      end
    end
  end

  describe 'update' do

    describe 'with a valid id' do
      before( :each ) do
        @post = Factory.build( :post )
        Post.stubs( :find ).returns( @post )
      end
      describe 'when preview clicked' do
        before( :each ) do
          put :update, :preview_button => 'Preview', :id => @post.object_id, :post => {}, :subdomains => ['blog']
        end

        it { should respond_with( :success ) }
        it { should assign_to( :post ).with( @post ) }
        it { should assign_to( :preview ).with( true ) }
        it { should render_template( :edit ) }
      end

      describe 'when submit clicked' do
        describe 'and save succeeds' do
          before( :each ) do
            put :update, :id => @post.object_id, :post => {}, :subdomains => ['blog']
          end

          it { should redirect_to( @post.url ) }
          it { should set_the_flash }
        end

        describe 'and save fails' do
          before( :each ) do
            @post.stubs( :update_attributes ).returns( false )
            put :update, :id => @post.object_id, :post => {}, :subdomains => ['blog']
          end

          it { should set_the_flash }
          it { should render_template( :edit ) }
        end
      end
    end

    describe 'with an invalid id' do
      before( :each ) do
        Post.stubs( :find ).raises( ActiveRecord::RecordNotFound )
      end

      it 'should fail' do
        lambda { put :update, :id => 1, :post => {}, :subdomains => ['blog'] }.should raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE' do
    before( :each ) do
      @post = Factory.create( :post )
      @post.stubs( :delete ).returns( true )
      Post.stubs( :find ).returns( @post )
    end

    describe 'with a valid id' do
      before( :each ) do
        delete :destroy, :id => @post.id, :subdomains => ['blog']
      end

      it { should redirect_to( blog_posts_url ) }
    end
  end
end
