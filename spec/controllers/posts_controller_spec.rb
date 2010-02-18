require 'spec_helper'

describe PostsController do
	before( :each ) do
		@post = Factory.create( :post )
	end

	#===============
	# NOT LOGGED IN
	#===============
	describe "when not logged in" do

		#
		# INDEX
		#
		describe "GET 'index'" do
			before( :each ) do
				@posts = [@post]
				Post.stub!( :find ).with( :all ).and_return( @posts )
				get :index
			end

			it { should respond_with( :success ) }
			it { should assign_to( :posts ).with( @posts ) }
		end

		#
		# SHOW
		#
		describe "GET 'show'" do
			describe "with a valid id" do
				before( :each ) do
					Post.stub( :find_by_slug ).with( @post.slug ).and_return( @post )
					get :show, :slug => @post.slug
				end

				it { should respond_with( :success ) }
				it { should assign_to( :post ).with( @post ) }
			end

			describe "with an invalid id" do

				it "should fail with 404" do
					Post.stub( :find_by_slug ).and_return( nil )
					lambda { get :show, :slug => "invalid-slug" }.should raise_error ActiveRecord::RecordNotFound
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
				lambda { get :edit }.should raise_error PermissionDenied
			end
		end

		#
		# CREATE
		#
		describe "POST 'create'" do
			it "should raise a 403" do
				lambda { post :create, :post => { } }.should raise_error PermissionDenied
			end
		end

		#
		# UPDATE
		#
		describe "PUT 'update'" do
			it "should raise a 403" do
				lambda { put :update, :id => "1", :post => { } }.should raise_error PermissionDenied
			end
		end

		#
		# DELETE
		#
		describe "DELETE 'delete'" do
			it "should raise a 403" do
				lambda { delete :destroy, :id => "1" }.should raise_error PermissionDenied
			end
		end
	end

	#===============
	# ADMIN LOGIN
	#===============
	describe "when logged in as an admin" do
		before( :each ) do
			@user = Factory.create( :admin )
			controller.stub!( :current_user ).and_return( @user )
		end

		#
		# NEW
		#
		describe "GET 'new'" do
			before( :each ) do
				Post.should_receive( :new ).and_return( @post )
				get :new
			end

			it { should respond_with( :success ) }
			it { should assign_to( :post ).with( @post ) }
		end

		#
		# EDIT
		#
		describe "GET 'edit'" do
			describe "with a valid id" do
				before( :each ) do
					Post.should_receive( :find ).with( @post.id.to_s ).and_return( @post )
					get :edit, :id => @post.id
				end

				it { should respond_with( :success ) }
				it { should assign_to( :post ).with( @post ) }
			end
	
			describe "with an invalid id" do
				it "should fail" do
					Post.should_receive( :find ).with( ( @post.id + 1 ).to_s ).and_raise( ActiveRecord::RecordNotFound )
					lambda { get :edit, :id => @post.id + 1 }.should raise_error ActiveRecord::RecordNotFound
				end
			end
		end

		#
		# CREATE
		#
		describe "POST 'create'" do
			describe "when preview clicked" do
				before( :each ) do
					@new_body = "A new body with more *emphasized* text."
					@new_rendered_body = "<p>A new body with more <em>emphasized</em> text.</p>\n"
					@post = Factory.build( :new_post, :body => @new_body )
					Post.should_receive( :new ).and_return( @post )
					@post.should_not_receive( :save )
					post :create, :preview_button => "Preview", :post => {}
				end

				it { should respond_with( :success ) }
				it { should assign_to( :post ).with( @post ) }
				it { should assign_to( :preview ).with( true ) }
			end

			describe "when submit clicked" do
				describe "and save is successful" do
					before( :each ) do
						Post.should_receive( :new ).and_return( @post )
						@post.should_receive( :save ).and_return( true )
						post :create, :post => {}
					end
	
					it { should redirect_to( @post.url ) }
					it { should set_the_flash }
					it "should set user on @post" do
						assert_equal @user, @post.user
					end
				end

				describe "and save fails" do
					before( :each ) do
						Post.should_receive( :new ).and_return( @post )
						@post.should_receive( :save ).and_return( false )
						post :create, :post => {}
					end

					it { should set_the_flash }
					it { response.should render_template( :new ) } 
				end
			end
		end

		#
		# UPDATE
		#
		describe "PUT 'update'" do
			describe "with a valid id" do
				describe "when preview clicked" do
					before( :each ) do
						@new_body = "A new body with more *emphasized* text."
						@new_rendered_body = "<p>A new body with more <em>emphasized</em> text.</p>\n"
						Post.should_receive( :find ).with( @post.id.to_s ).and_return( @post )
						@post.should_not_receive( :update_attributes )
						put :update, :preview_button => "Preview", :id => @post.id, :post => { :body => @new_body}
					end

					it { should respond_with( :success ) }
					it { should assign_to( :post ).with( @post ) }
					it { should assign_to( :preview ).with( true ) }
				end

				describe "when submit clicked" do
					describe "and save succeeds" do
						before( :each ) do
							Post.should_receive( :find ).with( @post.id.to_s ).and_return( @post )
							@post.should_receive( :update_attributes ).and_return( true )
							put :update, :id => @post.id, :post => {}
						end
	
						it { should redirect_to( @post.url ) }
						it { should set_the_flash }
					end

					describe "and save fails" do
						before( :each ) do
							Post.should_receive( :find ).with( @post.id.to_s ).and_return( @post )
							@post.should_receive( :update_attributes ).and_return( false )
							put :update, :id => @post.id, :post => {}
						end

						it { should set_the_flash }
						it { should render_template( :edit ) }
					end
				end
			end

			describe "with an invalid id" do
				before( :each ) do
				end

				it "should fail" do
					Post.should_receive( :find ).with( ( @post.id + 1 ).to_s ).and_raise( ActiveRecord::RecordNotFound )
					lambda { put :update, :id => @post.id + 1, :post => {} }.should raise_error ActiveRecord::RecordNotFound
				end
			end
		end

		#
		# DELETE
		#
		describe "delete 'DELETE'" do
			describe "with a valid id" do
				before( :each ) do
					Post.stub( :find ).with( @post.id.to_s ).and_return( @post )
					@post.should_receive( :delete ).and_return( true )
					delete :destroy, :id => @post.id
				end

				it { should redirect_to( posts_url ) }
			end

			describe "with an invalid id" do
				it "should fail" do
					Post.should_receive( :find ).with( ( @post.id + 1 ).to_s ).and_raise( ActiveRecord::RecordNotFound )
					lambda { delete :destroy, :id => @post.id + 1, :post => {} }.should raise_error ActiveRecord::RecordNotFound
				end
			end
		end
	end
end
