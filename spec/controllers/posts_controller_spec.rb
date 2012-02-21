require 'spec_helper'

describe Blog::PostsController, 'as guest' do
  it { should require_authentication_for :new }
  it { should require_authentication_for :edit, :id => 1 }
  it { should require_authentication_for :create, :id => 1 }
  it { should require_authentication_for :update, :id => 1 }
  it { should require_authentication_for :destroy, :id => 1 }

  before { logout_user }

  describe "GET 'index'" do
    let(:paginated) { mock('paginated_posts') }
    let(:posts) { stub(:paginate => paginated) }
    before {
      Post.stubs(:recent).returns(posts)
      get :index
    }

    it { should respond_with(:success) }
    it { should render_template(:index) }
    it { should assign_to(:posts).with(paginated) }
  end

  describe "GET 'show'" do
    let(:blog_post) { Factory(:post) }
    before {
      Post.stubs(:find).returns(blog_post)
      get :show, :id => 1
    }

    it { should redirect_to(@request.protocol + @request.host + blog_post.url) }
  end

  describe 'show_by_slug' do
    let(:blog_post) { Factory(:post) }
    before {
      Post.stubs(:find_by_slug).returns(blog_post)
      get :show_by_slug, :year => 2010, :month => 02, :day => 01, :slug => 'test-title'
    }

    it { should respond_with(:success) }
    it { should render_template(:show) }
    it { should assign_to(:post).with(blog_post) }
    it { should assign_to(:comment).with_kind_of(Comment) }
  end
end

describe Blog::PostsController, 'as admin' do
  before { login_admin }

  describe "GET 'new'" do
    let(:blog_post) { mock('Post') }
    before {
      User.any_instance.stub_chain(:posts, :build).returns(blog_post)
      get :new
    }

    it { should render_template(:new) }
    it { should respond_with(:success) }
    it { should assign_to(:post).with(blog_post) }
  end

  describe "POST 'create'" do
    context 'when preview clicked' do
      let(:blog_post) { mock('Post') }
      before { User.any_instance.stub_chain(:posts, :build).returns(blog_post) }
      before { post :create, :preview_button => 'Preview', :post => {} }

      it { should respond_with(:success) }
      it { should render_template(:preview) }
      it { should assign_to(:post).with(blog_post) }
    end

    context 'when submit clicked' do
      let!(:blog_post) { Factory(:post) }
      before { User.any_instance.stub_chain(:posts, :build).returns(blog_post) }
      context 'with invalid attributes' do
        before {
          blog_post.stubs(:save).returns(false)
          post :create, :post => {}
        }
        it { should respond_with(:success) }
        it { should render_template(:new) }
        it { should assign_to(:post).with(blog_post) }
      end

      context 'with valid attributes' do
        before {
          blog_post.stubs(:save).returns(true)
          post :create, :post => {}
        }

        it { should redirect_to( blog_post.url ) }
        it { should set_the_flash }
      end

    end
  end

  describe "GET 'edit'" do
    let(:blog_post) { mock('Post') }
    before {
      Post.stubs(:find).returns(blog_post)
      get :edit, :id => 1
    }

    it { should respond_with(:success) }
    it { should render_template(:edit) }
    it { should assign_to(:post).with(blog_post) }
  end

  describe "PUT 'update'" do
    let(:blog_post) { Factory(:post) }
    before { Post.stubs(:find).returns(blog_post) }

    context 'when preview clicked' do
      before { put :update, :preview_button => 'Preview', :id => 1, :post => {} }

      it { should respond_with(:success) }
      it { should assign_to(:post).with(blog_post) }
      it { should render_template(:preview) }
    end

    context 'when submit clicked' do
      context 'and save fails' do
        before {
          blog_post.stubs(:update_attributes).returns( false )
          put :update, :id => 1, :post => {}
        }

        it { should respond_with(:success) }
        it { should render_template(:edit) }
        it { should assign_to(:post).with(blog_post) }
      end

      context 'and save succeeds' do
        before {
          blog_post.stubs(:update_attributes).returns(true)
          put :update, :id => 1, :post => {}
        }

        it { should redirect_to blog_post.url }
        it { should set_the_flash }
      end
    end
  end

  describe "DELETE 'destroy'" do
    let(:blog_post) { stub(:destroy => true) }
    before {
      Post.stubs(:find).returns(blog_post)
      delete :destroy, :id => 1
    }

    it { should redirect_to root_url(:subdomain => @request.subdomain) }
    it { should set_the_flash }
  end
end
