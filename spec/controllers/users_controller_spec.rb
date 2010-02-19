require 'spec_helper'

describe UsersController do

  #===============
  # NOT LOGGED IN
  #===============
  describe "when not logged in" do
    before( :each ) do
      @user = Factory.create( :user )
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
        lambda { get :show, :id => @user.id }.should raise_error PermissionDenied
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
        lambda { get :edit, :id => @user.id }.should raise_error PermissionDenied
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
        lambda { put :update, :id => @user.id, :user => {} }.should raise_error PermissionDenied
      end
    end

    #
    # DELETE
    #
    describe "DELETE 'delete'" do
      it "should return a 403" do
        lambda { delete :destroy, :id => @user.id }.should raise_error PermissionDenied
      end
    end
  end

  #===============
  # NORMAL USER
  #===============
  describe "when logged in as a normal user" do
    before( :each ) do
      @user = Factory.create( :user )
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
        lambda { get :show, :id => @user.id }.should raise_error PermissionDenied
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
        lambda { get :edit, :id => @user.id }.should raise_error PermissionDenied
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
        lambda { put :update, :id => @user.id, :user => {} }.should raise_error PermissionDenied
      end
    end

    #
    # DELETE
    #
    describe "DELETE 'delete'" do
      it "should return a 403" do
        lambda { delete :destroy, :id => @user.id }.should raise_error PermissionDenied
      end
    end
  end

  #===============
  # ADMIN LOGIN
  #===============
  describe "when logged in as an admin" do
    before( :each ) do
      @user = Factory.create( :user )
      @admin = Factory.create( :admin )
      @users = [@user]
      controller.stub( :current_user ).and_return( @admin )
    end

    #
    # INDEX
    #
    describe "GET 'index'" do
      before( :each ) do
        User.should_receive( :all ).and_return( @users )
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
      describe "with a valid id" do
        before( :each ) do
          User.should_receive( :find ).with( @user.id.to_s ).and_return( @user )
          get :show, :id => @user.id
        end

        it { should respond_with( :success ) }
        it { should assign_to( :user ).with( @user ) }
        it { should render_template( :show ) }
      end

      describe "with an invalid id" do
        it "should fail with 404" do
          User.should_receive( :find ).with( "1000" ).and_raise( ActiveRecord::RecordNotFound )
          lambda { get :show, :id => 1000 }.should raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    #
    # NEW
    #
    describe "GET 'new'" do
      before( :each ) do
        User.should_receive( :new ).and_return( @user )
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
      describe "with a valid id" do
        before( :each ) do
          User.should_receive( :find ).with( @user.id.to_s ).and_return( @user )
          get :edit, :id => @user.id
        end

        it { should respond_with( :success ) }
        it { should assign_to( :user ).with( @user ) }
        it { should render_template( :edit ) }
      end

      describe "with an invalid id" do
        it "should fail" do
          User.should_receive( :find ).with( ( @user.id + 1 ).to_s ).and_raise( ActiveRecord::RecordNotFound )
          lambda { get :edit, :id => @user.id + 1 }.should raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    #
    # CREATE
    #
    describe "POST 'create'" do
      describe "when save is successful" do
        before( :each ) do
          User.should_receive( :new ).and_return( @user )
          @user.should_receive( :save ).and_return( true )
          post :create, :user => {}
        end
  
        it { should redirect_to( users_path ) }
        it { should set_the_flash }
      end

      describe "when save is unsuccessful" do
        before( :each ) do
          User.should_receive( :new ).and_return( @user )
          @user.should_receive( :save ).and_return( false )
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
      describe "with a valid id" do
        describe "when save is successful" do
          before( :each ) do
            User.should_receive( :find ).with( @user.id.to_s ).and_return( @user )
            @user.should_receive( :update_attributes ).and_return( true )
            put :update, :id => @user.id, :user => @user
          end

          it { should set_the_flash }
          it { should redirect_to( users_path ) }
        end

        describe "when save fails" do
          before( :each ) do
            User.should_receive( :find ).with( @user.id.to_s ).and_return( @user )
            @user.should_receive( :update_attributes ).and_return( false )
            put :update, :id => @user.id, :user => @user
          end

          it { should set_the_flash }
          it { should render_template( :edit ) }
          it { should assign_to( :user ).with( @user ) }
        end
      end

      describe "with an invalid id" do
        it "should raise NotFound" do
          User.should_receive( :find ).with( @user.id.to_s ).and_raise( ActiveRecord::RecordNotFound )
          @user.should_not_receive( :update_attributes )
          lambda { put :update, :id => @user.id, :user => @user }.should raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    #
    # DELETE
    #
    describe "DELETE 'destroy'" do
      describe "with a valid id" do
        before( :each ) do
          User.should_receive( :find ).with( @user.id.to_s ).and_return( @user )
          @user.should_receive( :destroy ).and_return( true )
          delete :destroy, :id => @user.id
        end

        it { should set_the_flash }
        it { should redirect_to( users_path ) }
      end

      describe "with an invalid id" do
        it "should raise NotFound" do
          User.should_receive( :find ).with( @user.id.to_s ).and_raise( ActiveRecord::RecordNotFound )
          @user.should_not_receive( :destroy )
          lambda { delete :destroy, :id => @user.id }.should raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
#
# describe "DELETE destroy" do
#   it "destroys the requested user" do
#     User.should_receive(:find).with("37").and_return(mock_user)
#     mock_user.should_receive(:destroy)
#     delete :destroy, :id => "37"
#   end
#
#   it "redirects to the users list" do
#     User.stub(:find).and_return(mock_user(:destroy => true))
#     delete :destroy, :id => "1"
#     response.should redirect_to(users_url)
#   end
# end
end
