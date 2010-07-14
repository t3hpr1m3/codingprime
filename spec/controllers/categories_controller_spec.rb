require 'spec_helper'

describe CategoriesController do

  before( :each ) do
    logout_user
  end

  #===============
  # NOT LOGGED IN
  #===============
  describe "when not logged in" do

    #
    # INDEX
    #
    describe "GET 'index'" do
      it "should return a 403" do
        lambda { get :index }.should raise_error PermissionDenied
      end
    end

    #
    # SHOW
    #
    describe "GET 'show'" do
      describe "with a valid slug" do
        before( :each ) do
          @category = mock( 'category', :name => 'Test Category' )
          Category.stubs( :find_by_slug ).returns( @category )
          get :show, :id => 'test-category'
        end

        it { should respond_with( :success ) }
        it { should assign_to( :category ).with( @category ) }
        it { should render_template( :show ) }
      end

      describe "with an invalid slug" do
        before( :each ) do
          Category.stubs( :find_by_slug ).returns( nil )
        end

        it "should fail with 404" do
          lambda { get :show, :id => 'invalid-category' }.should raise_error( ActiveRecord::RecordNotFound )
        end
      end
    end

    #
    # NEW
    #
    describe "GET 'new'" do
      it "should raise a 403" do
        lambda { get :new }.should raise_error PermissionDenied
      end
    end

    #
    # EDIT
    #
    describe "GET 'edit'" do
      it "should raise a 403" do
        lambda { get :edit, :id => 'slug' }.should raise_error PermissionDenied
      end
    end

    #
    # CREATE
    #
    describe "POST 'create'" do
      it "should raise a 403" do
        lambda { post :create }.should raise_error PermissionDenied
      end
    end

    #
    # UPDATE
    #
    describe "PUT 'update'" do
      it "should raise a 403" do
        lambda { put :update, :id => 'slug' }.should raise_error PermissionDenied
      end
    end

    #
    # DELETE
    #
    describe "DELETE 'destroy'" do
      it "should raise a 403" do
        lambda { delete :destroy, :id => 'slug' }.should raise_error PermissionDenied
      end
    end
  end

  describe "when logged in as an admin" do
    before( :each ) do
      login_admin
    end

    #
    # NEW
    #
    describe "GET 'new'" do
      before( :each ) do
        @category = Category.new
        Category.stubs( :new ).returns( @category )
        get :new
      end

      it { should respond_with( :success ) }
      it { should assign_to( :category ).with( @category ) }
      it { should render_template( :new ) }
    end

    #
    # EDIT
    #
    describe "GET 'edit'" do
      describe "with a valid slug" do
        before( :each ) do
          @category = mock()
          Category.stubs( :find_by_slug ).returns( @category )
          get :edit, :id => 'test'
        end

        it { should respond_with( :success ) }
        it { should assign_to( :category ).with( @category ) }
        it { should render_template( :edit ) }
      end

      describe "with an invalid slug" do
        it "should fail" do
          Category.stubs( :find_by_slug ).raises( ActiveRecord::RecordNotFound )
          lambda { get :edit, :id => 'test' }.should raise_error( ActiveRecord::RecordNotFound )
        end
      end
    end

    #
    # CREATE
    #
    describe "POST 'create'" do
      describe "when save is successful" do
        before( :each ) do
          @category = stub( 'category' )
        end
      end
    end
  end
end
