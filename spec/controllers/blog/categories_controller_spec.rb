require 'spec_helper'

describe Blog::CategoriesController do
  #===============
  # NOT LOGGED IN
  #===============
  describe "when not logged in" do
    before( :each ) do
      logout_user
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
      it "should raise PermissionDenied" do
        lambda { get :new, { :subdomains => ["blog"] } }.should raise_error( PermissionDenied )
      end
    end

    #
    # EDIT
    #
    describe "GET 'edit'" do
      it "should raise PermissionDenied" do
        lambda { get :edit, { :id => "1", :subdomains => ["blog"] } }.should raise_error( PermissionDenied )
      end
    end

    #
    # CREATE
    #
    describe "POST 'create'" do
      it "should raise PermissionDenied" do
        lambda { post :create, { :post => {}, :subdomains => ["blog"] } }.should raise_error( PermissionDenied )
      end
    end

    #
    # CREATE
    #
    describe "PUT 'update'" do
      it "should raise PermissionDenied" do
        lambda { put :update, { :id => "1", :post => {}, :subdomains => ["blog"] } }.should raise_error( PermissionDenied )
      end
    end

    #
    # DELETE
    #
    describe "DELETE 'delete'" do
      it "should raise PermissionDenied" do
        lambda { delete :destroy, { :id => "1", :subdomains => ["blog"] } }.should raise_error( PermissionDenied )
      end
    end
  end

  describe "when logged in as a normal user" do
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

    #
    # NEW
    #
    describe "GET 'new'" do
      it "should raise PermissionDenied" do
        lambda { get :new, { :subdomains => ["blog"] } }.should raise_error( PermissionDenied )
      end
    end

    #
    # EDIT
    #
    describe "GET 'edit'" do
      it "should raise PermissionDenied" do
        lambda { get :edit, { :id => "1", :subdomains => ["blog"] } }.should raise_error( PermissionDenied )
      end
    end

    #
    # CREATE
    #
    describe "POST 'create'" do
      it "should raise PermissionDenied" do
        lambda { post :create, { :post => {}, :subdomains => ["blog"] } }.should raise_error( PermissionDenied )
      end
    end

    #
    # CREATE
    #
    describe "PUT 'update'" do
      it "should raise PermissionDenied" do
        lambda { put :update, { :id => "1", :post => {}, :subdomains => ["blog"] } }.should raise_error( PermissionDenied )
      end
    end

    #
    # DELETE
    #
    describe "DELETE 'delete'" do
      it "should raise PermissionDenied" do
        lambda { delete :destroy, { :id => "1", :subdomains => ["blog"] } }.should raise_error( PermissionDenied )
      end
    end
  end

  describe "when logged in as an admin" do
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
end
