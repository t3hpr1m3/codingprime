require 'spec_helper'

describe Blog::CategoriesController, 'as guest' do
  before { logout_user }

  it { should require_authentication_for( :new, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :edit, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :create, :post, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :update, :put, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :destroy, :delete, :id => 1, :subdomains => ['blog'] ) }

  let(:categories) { FactoryGirl.create_list(:category, 2) }
  describe 'index' do
    before {
      Category.stubs(:all).returns(categories)
      get :index#, { :subdomains => ["blog"] }
    }

    it { should respond_with(:success) }
    it { should assign_to(:categories).with(categories) }
    it { should render_template(:index) }
  end

  describe 'show' do
    let(:category) { Factory(:category) }
    before {
      Category.stubs(:find_by_slug).with(category.slug).returns(category)
      get :show, :id => category.slug
    }

    it { should respond_with(:success) }
    it { should assign_to(:category).with(category) }
    it { should render_template(:show) }
  end
end

describe Blog::CategoriesController, 'as normal user' do
  before { login_user }

  #
  # INDEX
  #
  describe "GET 'index'" do
    let(:categories) { FactoryGirl.create_list(:category, 2) }
    before {
      Category.stubs(:all).returns(categories)
      get :index
    }

    it { should respond_with(:success) }
    it { should assign_to(:categories).with(categories) }
    it { should render_template(:index) }
  end

  #
  # SHOW
  #
  describe "GET 'show'" do
    let(:category) { Factory(:category) }
    before {
      Category.stubs(:find_by_slug).with(category.slug).returns(category)
      get :show, :id => category.slug
    }

    it { should respond_with(:success) }
    it { should assign_to(:category).with(category) }
    it { should render_template(:show) }
  end

  it { should require_authentication_for( :new, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :edit, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :create, :post, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :update, :put, :id => 1, :subdomains => ['blog'] ) }
  it { should require_authentication_for( :destroy, :delete, :id => 1, :subdomains => ['blog'] ) }
end

describe Blog::CategoriesController, 'as admin' do
  before { login_admin }

  #
  # INDEX
  #
  describe "GET 'index'" do
    let(:categories) { FactoryGirl.create_list(:category, 2) }
    before {
      Category.stubs(:all).returns(categories)
      get :index
    }

    it { should respond_with(:success) }
    it { should assign_to(:categories).with(categories) }
    it { should render_template(:index) }
  end

  #
  # SHOW
  #
  describe "GET 'show'" do
    let(:category) { Factory(:category) }
    before {
      Category.stubs(:find_by_slug).with(category.slug).returns(category)
      get :show, :id => category.slug
    }

    it { should respond_with(:success) }
    it { should assign_to(:category).with(category) }
    it { should render_template(:show) }
  end

  #
  # NEW
  #
  describe "GET 'new'" do
    let!(:category) { Factory.build(:category) }
    before {
      Category.stubs(:new).returns(category)
      get :new
    }
    it { should respond_with(:success) }
    it { should assign_to(:category).with(category) }
    it { should render_template(:new) }
  end

  #
  # EDIT
  #
  describe "GET 'edit'" do
    let(:category) { Factory(:category) }
    before {
      Category.stubs(:find_by_slug).with(category.slug).returns(category)
      get :edit, :id => category.slug
    }
    it { should respond_with(:success) }
    it { should assign_to(:category).with(category) }
    it { should render_template(:edit) }
  end

  #
  # CREATE
  #
  describe "POST 'create'" do
    let!(:category) { Factory(:category) }
    before { Category.stubs(:new).returns(category) }

    context 'with invalid attributes' do
      before {
        category.stubs(:save).returns(false)
        post :create, :category => {}
      }
      it { should respond_with(:success) }
      it { should render_template(:new) }
      it { should assign_to(:category).with(category) }
    end

    describe 'with valid attributes' do
      before {
        category.stubs(:save).returns(true)
        post :create, :category => {}
      }
      it { should set_the_flash }
      it { should redirect_to(category) }
    end
  end

  #
  # UPDATE
  #
  describe "PUT 'update'" do
    let(:category) { Factory(:category) }
    before { Category.stubs(:find_by_slug).with(category.slug).returns(category) }

    context 'with invalid attributes' do
      before {
        category.stubs(:update_attributes).returns(false)
        put :update, :id => category.slug, :category => {}
      }
      it { should respond_with(:success) }
      it { should render_template(:edit) }
      it { should assign_to(:category).with(category) }
    end

    context 'with valid attributes' do
      before {
        category.stubs(:update_attributes).returns(true)
        put :update, :id => category.slug, :category => {}
      }
      it { should set_the_flash }
      it { should redirect_to(category) }
    end
  end

  #
  # DELETE
  #
  describe "DELETE 'destroy'" do
    let(:category) { stub(:destroy => true) }
    before {
      Category.stubs(:find_by_slug).returns(category)
      delete :destroy, :id => 1
    }
    it { should set_the_flash }
    it { should redirect_to root_url(:subdomain => 'blog') }
  end
end
