require 'spec_helper'

describe UsersController, 'as guest' do
  before( :each ) do
    logout_user
  end

  it { should require_authentication_for( :index ) }
  it { should require_authentication_for( :show, :id => 1 ) }
  it { should require_authentication_for( :new ) }
  it { should require_authentication_for( :edit, :id => 1 ) }
  it { should require_authentication_for( :create, :post ) }
  it { should require_authentication_for( :update, :put, :id => 1 ) }
  it { should require_authentication_for( :destroy, :delete, :id => 1 ) }
end

describe UsersController, 'as normal user' do
  before( :each ) do
    login_user
  end

  it { should require_authentication_for( :index ) }
  it { should require_authentication_for( :show, :id => 1 ) }
  it { should require_authentication_for( :new ) }
  it { should require_authentication_for( :edit, :id => 1 ) }
  it { should require_authentication_for( :create, :post ) }
  it { should require_authentication_for( :update, :put, :id => 1 ) }
  it { should require_authentication_for( :destroy, :delete, :id => 1 ) }
end

describe UsersController, 'as admin' do
  before( :each ) do
    login_admin
  end

  #
  # INDEX
  #
  describe "GET 'index'" do
    before( :each ) do
      @users = mock()
      User.stubs( :find ).returns( @users )
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
      @user = mock()
      User.stubs( :find ).returns( @user )
      get :show, :id => 1
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
      @user = mock()
      User.stubs( :new ).returns( @user )
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
      @user = mock()
      User.stubs( :find ).returns( @user )
      get :edit, :id => 1
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
        User.any_instance.stubs( :save ).returns( true )
        post :create, :user => {}
      end

      it { should redirect_to( users_path ) }
      it { should set_the_flash }
    end

    describe "when save is unsuccessful" do
      before( :each ) do
        User.any_instance.stubs( :save ).returns( false )
        post :create, :user => {}
      end

      it { should set_the_flash }
      it { should render_template( :new ) }
      it { should assign_to( :user ).with_kind_of( User ) }
    end
  end

  #
  # UPDATE
  #
  describe "PUT 'update'" do
    describe "when save is successful" do
      before( :each ) do
        @user = stub( :update_attributes => true )
        User.stubs( :find ).returns( @user )
        put :update, :id => 1, :user => {}
      end

      it { should set_the_flash }
      it { should redirect_to( users_path ) }
    end

    describe "when save fails" do
      before( :each ) do
        @user = stub( :update_attributes => false )
        User.stubs( :find ).returns( @user )
        put :update, :id => 1, :user => {}
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
      @user = stub( :destroy => true )
      User.stubs( :find ).returns( @user )
      delete :destroy, :id => @user.object_id
    end

    it { should set_the_flash }
    it { should redirect_to( users_path ) }
  end
end
