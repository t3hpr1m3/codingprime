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
        Category.expects( :find ).with( @category.id ).returns( @category )
        get :show, { :id => @category.id, :subdomains => ["blog"] }
      end

      it { should respond_with( :success ) }
      it { should assign_to( :category ).with( @category ) }
      it { should render_template( :show ) }
    end
  end
end
