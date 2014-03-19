require 'spec_helper'

describe Blog::PostsController do

  def slug_url(post)
    blog_post_by_slug_url(subdomain: 'blog', year: post.year, month: post.month, day: post.day, slug: post.slug)
  end

  def visit_slug_path(post)
    visit slug_url(post)
  end

  it 'should show recent posts' do
    Factory(:post, title: 'Awesome Post')
    visit blog_posts_url(subdomain: 'blog')
    page.should have_content('Awesome Post')
  end

  it 'should show a single post' do
    post = Factory(:post, title: 'Awesome Post')
    visit_slug_path(post)
    page.should have_selector('h2', :text => post.title)
  end

  context 'single post' do
    it 'should redirect to slug_url' do
      post = Factory(:post, title: 'Awesome Post')
      visit blog_post_url(post, subdomain: 'blog')
      page.current_url.should eq(slug_url(post))
    end

    it 'should show comments' do
      Comment.any_instance.stub(check_spam: true)
      post = Factory(:post, title: 'Awesome Post')
      Factory(:comment, comment_text: 'Cool Post!', approved: true, post: post)
      visit_slug_path(post)
      page.should have_content('Cool Post!')
    end

  end

  context 'as an admin' do
    let(:admin) { Factory(:admin) }
    before do
      login_as admin
    end

    it 'prevents invalid input' do
      visit blog_posts_url(subdomain: 'blog')
      click_on 'New Post'
      click_on 'Create'
      page.should have_content("Please correct the following errors:")
      page.should have_content("Title can't be blank")
      page.should have_content("Body can't be blank")
    end

    it 'allows previewing a post' do
      visit blog_posts_url(subdomain: 'blog')
      click_on 'New Post'
      fill_in 'Title', with: 'An Uncertain Title'
      fill_in 'Body', with: "I'm really not sure about this."
      click_on 'Preview'
      page.should have_selector('h2', text: 'An Uncertain Title')
    end

    it 'redirects to the post page after successful creation' do
      Factory(:category, name: 'Junk')
      Factory(:category, name: 'Musings')
      visit blog_posts_url(subdomain: 'blog')
      click_on 'New Post'
      fill_in 'Title', with: 'The Perfect Title'
      fill_in 'Body', with: 'The secret to happiness is...'
      select 'Musings', from: 'Category'
      click_on 'Create'
      page.current_path.should match(/^([0-9\/]+)the-perfect-title$/)
    end

    describe 'editing a post' do
      let!(:category) { Factory(:category, name: 'Musings') }
      let!(:post) { Factory(:post, title: 'Bad Post', category: category) }

      it 'prevents invalid input' do
        visit blog_posts_url(subdomain: 'blog')
        click_on 'Bad Post'
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Update'
        page.should have_content("Title can't be blank")
      end

      it 'should allow preview' do
        visit blog_posts_url(subdomain: 'blog')
        click_on 'Bad Post'
        click_on 'Edit'
        fill_in 'Title', with: 'Better Post'
        click_on 'Preview'
        page.should have_selector('h2', text: 'Better Post')
        page.should have_button('Preview')
      end

      it 'redirects to the post page' do
        visit blog_posts_url(subdomain: 'blog')
        click_on 'Bad Post'
        click_on 'Edit'
        fill_in 'Title', with: 'Better Post'
        click_on 'Update'
        page.current_path.should match(/^([0-9\/])+bad-post$/)
        page.should have_selector('h2', text: 'Better Post')
      end
    end

    describe 'deleting a post' do
      it 'should redirect to the posts page' do
        category = Factory(:category, name: 'Worthless')
        post = Factory(:post, title: 'Junk', category: category)
        visit blog_posts_url(subdomain: 'blog')
        click_on 'Junk'
        click_on 'Delete'
        page.should have_content('Post deleted.')
        page.current_path.should eq(blog_root_path)
      end
    end
  end
end
