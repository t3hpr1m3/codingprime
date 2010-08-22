require 'spec_helper'

describe Blog::CategoriesController, 'as guest' do
  before( :each ) do
    logout_user
  end

  it { should require_authentication_for( :get, :new, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :get, :edit, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :post, :create, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :put, :update, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :delete, :destroy, :id => 1, :subdomains => ['blog'] ) }

  describe 'index' do
    before( :each ) do
      @categories = mock()
      Category.expects( :find ).with( :all ).returns( @categories )
      get :index, { :subdomains => ["blog"] }
    end

    it { should respond_with( :success ) }
    it { should assign_to( :categories ).with( @categories ) }
    it { should render_template( :index ) }
  end

  describe 'show' do
    before( :each ) do
      @category = Factory.create( :category )
      Category.expects( :find_by_slug ).with( @category.slug ).returns( @category )
      get :show, { :id => @category.slug, :subdomains => ["blog"] }
    end

    it { should respond_with( :success ) }
    it { should assign_to( :category ).with( @category ) }
    it { should render_template( :show ) }
  end
end

describe Blog::CategoriesController, 'as normal user' do
  before( :each ) do
    login_user
  end

  #
  # INDEX
  #
  describe "GET 'index'" do
    before( :each ) do
      @categories = mock()
      Category.expects( :find ).with( :all ).returns( @categories )
      get :index, { :subdomains => ["blog"] }
    end

    it { should respond_with( :success ) }
    it { should assign_to( :categories ).with( @categories ) }
    it { should render_template( :index ) }
  end

  #
  # SHOW
  #
  describe "GET 'show'" do
    before( :each ) do
      @category = Factory.create( :category )
      Category.expects( :find_by_slug ).with( @category.slug ).returns( @category )
      get :show, { :id => @category.slug, :subdomains => ["blog"] }
    end

    it { should respond_with( :success ) }
    it { should assign_to( :category ).with( @category ) }
    it { should render_template( :show ) }
  end

  it { should require_authentication_for( :get, :new, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :get, :edit, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :post, :create, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :put, :update, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :delete, :destroy, :id => 1, :subdomains => ['blog'] ) }
end

describe Blog::CategoriesController, 'as admin' do
  before( :each ) do
    login_admin
  end

  #
  # INDEX
  #
  describe "GET 'index'" do
    before( :each ) do
      @categories = mock()
      Category.expects( :find ).with( :all ).returns( @categories )
      get :index, { :subdomains => ["blog"] }
    end

    it { should respond_with( :success ) }
    it { should assign_to( :categories ).with( @categories ) }
    it { should render_template( :index ) }
  end

  #
  # SHOW
  #
  describe "GET 'show'" do
    before( :each ) do
      @category = Factory.create( :category )
      Category.expects( :find_by_slug ).with( @category.slug ).returns( @category )
      get :show, { :id => @category.slug, :subdomains => ["blog"] }
    end

    it { should respond_with( :success ) }
    it { should assign_to( :category ).with( @category ) }
    it { should render_template( :show ) }
  end

  #
  # NEW
  #
  describe "GET 'new'" do
    before( :each ) do
      @category = Category.new
      Category.stubs( :new ).returns( @category )
      get :new, { :subdomains => ["blog"] }
    end
    it { should respond_with( :success ) }
    it { should assign_to( :category).with( @category ) }
    it { should render_template( :new ) }
  end

  #
  # EDIT
  #
  describe "GET 'edit'" do
    describe "with a valid id" do
      before( :each ) do
        @category = Factory.create( :category )
        Category.stubs( :find ).returns( @category )
        get :edit, { :id => @category.id, :subdomains => ["blog"] }
      end
      it { should respond_with( :success ) }
      it { should assign_to( :category ).with( @category ) }
      it { should render_template( :edit ) }
    end

    describe "with an invalid id" do
      it "should fail" do
        Category.stubs( :find ).returns( nil )
        lambda { get :edit, { :id => 1, :subdomains => ["blog"] } }.should raise_error( ActiveRecord::RecordNotFound )
      end
    end
  end

  #
  # CREATE
  #
  describe "POST 'create'" do
    describe "with a duplicate name" do
      before( :each ) do
        @category = Factory.create( :category )
        post :create, { :category => Factory.attributes_for( :category, { :name => @category.name } ), :subdomains => ["blog"] }
      end
      it { should set_the_flash }
      it { should render_template( :new ) }
    end

    describe "with a valid name" do
      before( :each ) do
        @category = Factory.create( :category )
        @category.stubs( :save ).returns( true )
        Category.stubs( :new ).returns( @category )
        post :create, { :category => {}, :subdomains => ["blog"] }
      end
      it { should set_the_flash }
      it { should redirect_to( blog_category_path( @category ) ) }
    end
  end

  #
  # UPDATE
  #
  describe "PUT 'update'" do
    describe "with a duplicate name" do
      before( :each ) do
        @category = Factory.create( :category )
        @dup = Factory.create( :category )
        Category.stubs( :find ).returns( @dup )
        put :update, { :id => @dup.id, :category => Factory.attributes_for( :category, { :name => @category.name } ), :subdomains => ["blog"] }
      end
      it { should set_the_flash }
      it { should render_template( :edit ) }
    end

    describe "with a valid name" do
      before( :each ) do
        @category = Factory.create( :category )
        @category.stubs( :save ).returns( true )
        Category.stubs( :find ).returns( @category )
        put :update, { :id => @category.id, :category => {}, :subdomains => ["blog"] }
      end
      it { should set_the_flash }
      it { should redirect_to( blog_category_path( @category ) ) }
    end
  end

  #
  # DELETE
  #
  describe "delete 'delete'" do
    describe "with an invalid id" do
      it "should raise RecordNotFound" do
        Category.stubs( :find ).returns( nil )
        lambda { delete :destroy, { :id => 1, :subdomains => ["blog"] } }.should raise_error( ActiveRecord::RecordNotFound )
      end
    end

    describe "with a valid id" do
      before( :each ) do
        @category = Factory.create( :category )
        @category.stubs( :delete ).returns( true )
        Category.stubs( :find ).returns( @category )
        delete :destroy, { :id => @category.id, :subdomains => ["blog"] }
      end
      it { should set_the_flash }
      it { should redirect_to( blog_root_path ) }
    end
  end
end
