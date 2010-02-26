require 'spec_helper'

describe UsersController do

  #===============
  # NOT LOGGED IN
  #===============
  describe "when not logged in" do
    before( :each ) do
      controller.stub( :current_user ).and_return( nil )
    end

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
      it "should return a 403" do
        lambda { get :show, :id => 1 }.should raise_error PermissionDenied
      end
    end

    #
    # NEW
    #
    describe "GET 'new'" do
      it "should return a 403" do
        lambda { get :new }.should raise_error PermissionDenied
      end
    end

    #
    # EDIT
    #
    describe "GET 'edit'" do
      it "should return a 403" do
        lambda { get :edit, :id => 1 }.should raise_error PermissionDenied
      end
    end

    #
    # CREATE
    #
    describe "POST 'create'" do
      it "should return a 403" do
        lambda { post :create, :user => {} }.should raise_error PermissionDenied
      end
    end

    #
    # UPDATE
    #
    describe "PUT 'update'" do
      it "should return a 403" do
        lambda { put :update, :id => 1, :user => {} }.should raise_error PermissionDenied
      end
    end

    #
    # DELETE
    #
    describe "DELETE 'delete'" do
      it "should return a 403" do
        lambda { delete :destroy, :id => 1 }.should raise_error PermissionDenied
      end
    end
  end

  #===============
  # NORMAL USER
  #===============
  describe "when logged in as a normal user" do
    before( :each ) do
      @user = mock_model( User, :is_admin => false )
      controller.stub( :current_user ).and_return( @user )
    end

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
      it "should return a 403" do
        lambda { get :show, :id => 1 }.should raise_error PermissionDenied
      end
    end

    #
    # NEW
    #
    describe "GET 'new'" do
      it "should return a 403" do
        lambda { get :new }.should raise_error PermissionDenied
      end
    end

    #
    # EDIT
    #
    describe "GET 'edit'" do
      it "should return a 403" do
        lambda { get :edit, :id => 1 }.should raise_error PermissionDenied
      end
    end

    #
    # CREATE
    #
    describe "POST 'create'" do
      it "should return a 403" do
        lambda { post :create, :user => {} }.should raise_error PermissionDenied
      end
    end

    #
    # UPDATE
    #
    describe "PUT 'update'" do
      it "should return a 403" do
        lambda { put :update, :id => 1, :user => {} }.should raise_error PermissionDenied
      end
    end

    #
    # DELETE
    #
    describe "DELETE 'delete'" do
      it "should return a 403" do
        lambda { delete :destroy, :id => 1 }.should raise_error PermissionDenied
      end
    end
  end

  #===============
  # ADMIN LOGIN
  #===============
  describe "when logged in as an admin" do
    before( :each ) do
      @admin = mock_model( User, :is_admin => true )
      controller.stub!( :current_user ).and_return( @admin )
    end

    #
    # INDEX
    #
    describe "GET 'index'" do
      before( :each ) do
        @users = [mock_model( User )]
        User.stub!( :find ).and_return( @users )
        get :index
      end

      it { should respond_with( :success ) }
      it { should assign_to( :users ).with( @users ) }
      it { should render_template( :index ) }
    end

    #
    # SHOW
    #
    describe "GET 'show'" do
      before( :each ) do
        @user = mock_model( User )
        User.stub( :find ).and_return( @user )
        get :show, :id => @user.object_id
      end

      it { should respond_with( :success ) }
      it { should assign_to( :user ).with( @user ) }
      it { should render_template( :show ) }
    end

    #
    # NEW
    #
    describe "GET 'new'" do
      before( :each ) do
        @user = User.new
        User.stub!( :new ).and_return( @user )
        get :new
      end

      it { should respond_with( :success ) }
      it { should assign_to( :user ).with( @user ) }
      it { should render_template( :new ) }
    end

    #
    # EDIT
    #
    describe "GET 'edit'" do
      before( :each ) do
        @user = mock_model( User )
        User.stub!( :find ).and_return( @user )
        get :edit, :id => @user.id
      end

      it { should respond_with( :success ) }
      it { should assign_to( :user ).with( @user ) }
      it { should render_template( :edit ) }
    end

    #
    # CREATE
    #
    describe "POST 'create'" do
      describe "when save is successful" do
        before( :each ) do
          @user = mock_model( User )
          User.stub!( :new ).and_return( @user )
          @user.stub!( :save ).and_return( true )
          post :create, :user => {}
        end
  
        it { should redirect_to( users_path ) }
        it { should set_the_flash }
      end

      describe "when save is unsuccessful" do
        before( :each ) do
          @user = mock_model( User )
          User.stub!( :new ).and_return( @user )
          @user.stub!( :save ).and_return( false )
          post :create, :user => {}
        end

        it { should set_the_flash }
        it { should render_template( :new ) }
        it { should assign_to( :user ).with( @user ) }
      end
    end

    #
    # UPDATE
    #
    describe "PUT 'update'" do
      describe "when save is successful" do
        before( :each ) do
          @user = mock_model( User )
          User.stub!( :find ).and_return( @user )
          @user.stub!( :update_attributes ).and_return( true )
          put :update, :id => @user.object_id, :user => {}
        end

        it { should set_the_flash }
        it { should redirect_to( users_path ) }
      end

      describe "when save fails" do
        before( :each ) do
          @user = mock_model( User )
          User.stub!( :find ).and_return( @user )
          @user.stub!( :update_attributes ).and_return( false )
          put :update, :id => @user.object_id, :user => {}
        end

        it { should set_the_flash }
        it { should render_template( :edit ) }
        it { should assign_to( :user ).with( @user ) }
      end
    end

    #
    # DELETE
    #
    describe "DELETE 'destroy'" do
      before( :each ) do
        @user = mock_model( User )
        User.stub!( :find ).and_return( @user )
        @user.stub!( :destroy ).and_return( true )
        delete :destroy, :id => @user.object_id
      end

      it { should set_the_flash }
      it { should redirect_to( users_path ) }
    end
  end
end
