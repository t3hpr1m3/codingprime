require 'spec_helper'

describe Blog::PostsController do
#  def mock_post( stubs = nil )
#    args = {
#      :title => 'Test Post',
#      :year => '2010',
#      :month => '02',
#      :day => '25',
#      :slug => 'test-post',
#      :url => '/test-post',
#      :user => nil
#    }
#    if stubs
#      args = args.merge( stubs )
#    end
#    mock_model( Post, args )
#  end
#
#  def mock_admin_user( stubs = nil )
#    args = { :is_admin => true }
#    if stubs
#      args = args.merge( stubs )
#    end
#    mock_model( User, args )
#  end

  #===============
  # NOT LOGGED IN
  #===============
  describe "when not logged in" do

    #
    # INDEX
    #
    describe "GET 'index'" do
      before( :each ) do
        @posts = mock()
        Post.stubs( :find ).with( :all ).returns( @posts )
        get :index, {:subdomains => ["blog"]}
      end

      it { should respond_with( :success ) }
      it { should assign_to( :posts ).with( @posts ) }
      it { should render_template( :index ) }
    end

    #
    # SHOW
    #
    describe "GET 'show'" do
      describe "with a valid id" do
        before( :each ) do
          @post = mock( 'post' ) do
	    expects( :url ).times( 2 ).returns( '/slug_url' )
	  end
          Post.stubs( :find ).returns( @post )
          #get :show, :id => 1
          get :show, {:id => 1, :subdomains => ["blog"]}
        end

        it { should redirect_to( @request.protocol + @request.host + @post.url ) }
        #it { should respond_with( :success ) }
        #it { should assign_to( :post ).with( @post ) }
        #it { should render_template( :show ) }
      end
    end

    #
    # SHOW_BY_SLUG
    #
    describe "GET 'show_by_slug'" do
      describe "with a valid slug" do
        before( :each ) do
          @post = mock( 'post', :title => 'Test Title' )
          Post.stubs( :find_by_slug ).returns( @post )
          get :show_by_slug , :year => 2010, :month => 02, :day => 01, :slug => 'test-title', :subdomains => ['blog']
        end

        it { should respond_with( :success ) }
        it { should assign_to( :post ).with( @post ) }
        it { should render_template( :show ) }
      end

      describe "with an invalid slug" do

        it "should fail with 404" do
	  Post.stubs( :find_by_slug ).returns( nil )
          lambda { get :show_by_slug, :year => 2010, :month => 02, :day => 01, :slug => "invalid-slug", :subdomains => ['blog'] }.should raise_error ActiveRecord::RecordNotFound
        end
      end
    end
#
#    #
#    # NEW
#    #
#    describe "GET 'new'" do
#      it "should raise a 403" do
#        controller.stub!( :current_user ).and_return
#        lambda { get :new }.should raise_error PermissionDenied
#      end
#    end
#
#    #
#    # EDIT
#    #
#    describe "GET 'edit'" do
#      it "should raise a 403" do
#        controller.stub!( :current_user ).and_return
#        lambda { get :edit, :id => "1" }.should raise_error PermissionDenied
#      end
#    end
#
#    #
#    # CREATE
#    #
#    describe "POST 'create'" do
#      it "should raise a 403" do
#        controller.stub!( :current_user ).and_return
#        lambda { post :create, :post => { } }.should raise_error PermissionDenied
#      end
#    end
#
#    #
#    # UPDATE
#    #
#    describe "PUT 'update'" do
#      it "should raise a 403" do
#        controller.stub!( :current_user ).and_return
#        lambda { put :update, :id => "1", :post => { } }.should raise_error PermissionDenied
#      end
#    end
#
#    #
#    # DELETE
#    #
#    describe "DELETE 'delete'" do
#      it "should raise a 403" do
#        controller.stub!( :current_user ).and_return
#        lambda { delete :destroy, :id => "1" }.should raise_error PermissionDenied
#      end
#    end
  end

#  #===============
#  # ADMIN LOGIN
#  #===============
#  describe "when logged in as an admin" do
#
#    #
#    # NEW
#    #
#    describe "GET 'new'" do
#      before( :each ) do
#        @admin = mock_admin_user
#        controller.stub!( :current_user ).and_return( @admin )
#        @post = Post.new
#        Post.stub!( :new ).and_return( @post )
#        get :new
#      end
#
#      it { should respond_with( :success ) }
#      it { should assign_to( :post ).with( @post ) }
#      it { should render_template( :new ) }
#    end
#
#    #
#    # EDIT
#    #
#    describe "GET 'edit'" do
#      def do_stubs
#        @admin = mock_admin_user
#        controller.stub!( :current_user ).and_return( @admin )
#        @post = mock_post
#      end
#
#      describe "with a valid id" do
#        before( :each ) do
#          do_stubs
#          Post.stub!( :find ).and_return( @post )
#          get :edit, :id => @post.object_id
#        end
#
#        it { should respond_with( :success ) }
#        it { should assign_to( :post ).with( @post ) }
#        it { should render_template( :edit ) }
#      end
#  
#      describe "with an invalid id" do
#        it "should fail" do
#          do_stubs
#          Post.stub!( :find ).and_raise( ActiveRecord::RecordNotFound )
#          lambda { get :edit, :id => 1 }.should raise_error ActiveRecord::RecordNotFound
#        end
#      end
#    end
#
#    #
#    # CREATE
#    #
#    describe "POST 'create'" do
#      def do_stubs
#          @admin = mock_admin_user
#          controller.stub!( :current_user ).and_return( @admin )
#          @post = mock_post
#          Post.stub!( :new ).and_return( @post )
#          @post.stub!( :save ).and_return( true )
#      end
#
#      describe "when preview clicked" do
#        before( :each ) do
#          do_stubs
#          post :create, :preview_button => "Preview", :post => {}
#        end
#
#        it { should respond_with( :success ) }
#        it { should assign_to( :post ).with_kind_of( Post ) }
#        it { should assign_to( :preview ).with( true ) }
#        it { should render_template( :new ) }
#      end
#
#      describe "when submit clicked" do
#        describe "and save is successful" do
#          before( :each ) do
#            do_stubs
#            @post.should_receive( :user= ).with( @admin )
#            post :create, :post => {}
#          end
#  
#          it { should redirect_to( @post.url ) }
#          it { should set_the_flash }
#        end
#
#        describe "and save fails" do
#          before( :each ) do
#            do_stubs
#            @post.stub!( :user= ).and_return( @admin_user )
#            @post.stub!( :save ).and_return( false )
#            post :create, :post => {}
#          end
#
#          it { should set_the_flash }
#          it { response.should render_template( :new ) } 
#        end
#      end
#    end
#
#    #
#    # UPDATE
#    #
#    describe "PUT 'update'" do
#      def do_stubs
#        @admin = mock_admin_user
#        controller.stub!( :current_user ).and_return( @admin )
#        @post = mock_post
#        Post.stub!( :find ).and_return( @post )
#        @post.stub!( :attributes= )
#        @post.stub!( :update_attributes ).and_return( true )
#      end
#
#      describe "with a valid id" do
#        describe "when preview clicked" do
#          before( :each ) do
#            do_stubs
#            put :update, :preview_button => "Preview", :id => @post.object_id, :post => {}
#          end
#
#          it { should respond_with( :success ) }
#          it { should assign_to( :post ).with( @post ) }
#          it { should assign_to( :preview ).with( true ) }
#          it { should render_template( :edit ) }
#        end
#
#        describe "when submit clicked" do
#          describe "and save succeeds" do
#            before( :each ) do
#              do_stubs
#              put :update, :id => @post.object_id, :post => {}
#            end
#  
#            it { should redirect_to( @post.url ) }
#            it { should set_the_flash }
#          end
#
#          describe "and save fails" do
#            before( :each ) do
#              do_stubs
#              @post.stub!( :update_attributes ).and_return( false )
#              put :update, :id => @post.object_id, :post => {}
#            end
#
#            it { should set_the_flash }
#            it { should render_template( :edit ) }
#          end
#        end
#      end
#
#      describe "with an invalid id" do
#        before( :each ) do
#          do_stubs
#          Post.stub!( :find ).and_raise( ActiveRecord::RecordNotFound )
#        end
#
#        it "should fail" do
#          lambda { put :update, :id => 1, :post => {} }.should raise_error ActiveRecord::RecordNotFound
#        end
#      end
#    end
#
#    #
#    # DELETE
#    #
#    describe "delete 'DELETE'" do
#      def do_stubs
#        @admin = mock_admin_user
#        controller.stub!( :current_user ).and_return( @admin )
#        @post = mock_post
#        Post.stub!( :find ).and_return( @post )
#        @post.stub!( :delete ).and_return( true )
#      end
#
#      describe "with a valid id" do
#        before( :each ) do
#          do_stubs
#          delete :destroy, :id => @post.id
#        end
#
#        it { should redirect_to( posts_url ) }
#      end
#    end
#  end
end
