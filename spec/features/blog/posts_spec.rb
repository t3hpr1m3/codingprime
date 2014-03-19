require 'spec_helper'

describe Blog::PostsController do

  def slug_url(post)
    blog_post_by_slug_url(subdomain: 'blog', year: post.year, month: post.month, day: post.day, slug: post.slug)
  end

  def visit_slug_path(post)
    visit slug_url(post)
  end

  it 'should show recent posts' do
    create(:post, title: 'Awesome Post')
    visit blog_posts_url(subdomain: 'blog')
    expect(page).to have_content('Awesome Post')
  end

  it 'should show a single post' do
    post = create(:post, title: 'Awesome Post')
    visit_slug_path(post)
    expect(page).to have_selector('h2', :text => post.title)
  end

  context 'single post' do
    it 'should redirect to slug_url' do
      post = create(:post, title: 'Awesome Post')
      visit blog_post_url(post, subdomain: 'blog')
      expect(page.current_url).to eq(slug_url(post))
    end

    it 'should show comments' do
      allow_any_instance_of(Comment).to receive(:check_spam).and_return(true)
      post = create(:post, title: 'Awesome Post')
      create(:comment, comment_text: 'Cool Post!', approved: true, post: post)
      visit_slug_path(post)
      expect(page).to have_content('Cool Post!')
    end

  end

  context 'as an admin' do
    let(:admin) { create(:admin) }
    before do
      login_as admin
    end

    it 'prevents invalid input' do
      visit blog_posts_url(subdomain: 'blog')
      click_on 'New Post'
      click_on 'Create'
      expect(page).to have_content("Please correct the following errors:")
      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content("Body can't be blank")
    end

    it 'allows previewing a post' do
      visit blog_posts_url(subdomain: 'blog')
      click_on 'New Post'
      fill_in 'Title', with: 'An Uncertain Title'
      fill_in 'Body', with: "I'm really not sure about this."
      click_on 'Preview'
      expect(page).to have_selector('h2', text: 'An Uncertain Title')
    end

    it 'redirects to the post page after successful creation' do
      create(:category, name: 'Junk')
      create(:category, name: 'Musings')
      visit blog_posts_url(subdomain: 'blog')
      click_on 'New Post'
      fill_in 'Title', with: 'The Perfect Title'
      fill_in 'Body', with: 'The secret to happiness is...'
      select 'Musings', from: 'Category'
      click_on 'Create'
      expect(page.current_path).to match(/^([0-9\/]+)the-perfect-title$/)
    end

    describe 'editing a post' do
      let!(:category) { create(:category, name: 'Musings') }
      let!(:post) { create(:post, title: 'Bad Post', category: category) }

      it 'prevents invalid input' do
        visit blog_posts_url(subdomain: 'blog')
        click_on 'Bad Post'
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Update'
        expect(page).to have_content("Title can't be blank")
      end

      it 'should allow preview' do
        visit blog_posts_url(subdomain: 'blog')
        click_on 'Bad Post'
        click_on 'Edit'
        fill_in 'Title', with: 'Better Post'
        click_on 'Preview'
        expect(page).to have_selector('h2', text: 'Better Post')
        expect(page).to have_button('Preview')
      end

      it 'redirects to the post page' do
        visit blog_posts_url(subdomain: 'blog')
        click_on 'Bad Post'
        click_on 'Edit'
        fill_in 'Title', with: 'Better Post'
        click_on 'Update'
        expect(page.current_path).to match(/^([0-9\/])+bad-post$/)
        expect(page).to have_selector('h2', text: 'Better Post')
      end
    end

    describe 'deleting a post' do
      it 'should redirect to the posts page' do
        category = create(:category, name: 'Worthless')
        post = create(:post, title: 'Junk', category: category)
        visit blog_posts_url(subdomain: 'blog')
        click_on 'Junk'
        click_on 'Delete'
        expect(page).to have_content('Post deleted.')
        expect(page.current_path).to eq(blog_root_path)
      end
    end
  end
end
