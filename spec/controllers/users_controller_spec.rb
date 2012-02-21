require 'spec_helper'

describe UsersController, 'as guest' do
  before { logout_user }

  it { should require_authentication_for :index }
  it { should require_authentication_for :show, :id => 1 }
  it { should require_authentication_for :new }
  it { should require_authentication_for :edit, :id => 1 }
  it { should require_authentication_for :create, :id => 1 }
  it { should require_authentication_for :update, :id => 1 }
  it { should require_authentication_for :destroy, :id => 1 }
end

describe UsersController, 'as admin' do
  before { login_admin }

  #
  # INDEX
  #
  describe "GET 'index'" do
    let(:users) { mock('Users') }
    before {
      User.stubs(:all).returns(users)
      get :index
    }

    it { should respond_with(:success) }
    it { should render_template(:index) }
    it { should assign_to(:users).with(users) }
  end

  #
  # SHOW
  #
  describe "GET 'show'" do
    let(:user) { mock('User') }
    before {
      User.stubs(:find).returns(user)
      get :show, :id => 1
    }

    it { should respond_with(:success) }
    it { should render_template(:show) }
    it { should assign_to(:user).with(user) }
  end

  #
  # NEW
  #
  describe "GET 'new'" do
    let(:user) { mock('User') }
    before {
      User.stubs(:new).returns(user)
      get :new
    }

    it { should respond_with(:success) }
    it { should render_template(:new) }
    it { should assign_to(:user).with(user) }
  end

  #
  # EDIT
  #
  describe "GET 'edit'" do
    let(:user) { mock('User') }
    before {
      User.stubs(:find).returns(user)
      get :edit, :id => 1
    }

    it { should respond_with(:success) }
    it { should render_template(:edit) }
    it { should assign_to(:user).with(user) }
  end

  #
  # CREATE
  #
  describe "POST 'create'" do
    let!(:user) { mock('User') }
    before { User.stubs(:new).returns(user) }

    context 'with invalid arguments' do
      before {
        user.stubs(:save).returns(false)
        post :create, :user => {}
      }
      it { should respond_with(:success) }
      it { should render_template(:new) }
      it { should assign_to(:user).with(user) }
    end

    context 'with valid arguments' do
      before {
        user.stubs(:save).returns(true)
        post :create, :user => {}
      }

      it { should redirect_to(users_path) }
      it { should set_the_flash }
    end
  end

  #
  # UPDATE
  #
  describe "PUT 'update'" do
    let(:user) { mock('User') }
    before { User.stubs(:find).returns(user) }

    context 'with invalid attributes' do
      before {
        user.stubs(:update_attributes).returns(false)
        put :update, :id => 1, :user => {}
      }
      it { should respond_with(:success) }
      it { should render_template(:edit) }
      it { should assign_to(:user).with(user) }
    end

    context 'with valid attributes' do
      before {
        user.stubs(:update_attributes).returns(true)
        put :update, :id => 1, :user => {}
      }
      it { should set_the_flash }
      it { should redirect_to users_path }
    end
  end

  #
  # DELETE
  #
  describe "DELETE 'destroy'" do
    let(:user) { stub(:destroy => true) }
    before {
      User.stubs(:find).returns(user)
      delete :destroy, :id => 1
    }

    it { should set_the_flash }
    it { should redirect_to users_path }
  end
end
