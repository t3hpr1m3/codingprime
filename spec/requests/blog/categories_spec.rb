require 'spec_helper'

describe Blog::CategoriesController do
  describe 'category listing' do
    it 'should list categories' do
      category = Factory(:category)
      visit blog_categories_url(subdomain: 'blog')
      page.should have_selector('td', text: category.slug)
    end

    it 'should show the post count' do
      category1 = Factory(:category, name: 'Empty')
      category2 = Factory(:category, name: 'Full')
      post = Factory(:post, category: category2)
      visit blog_categories_url(subdomain: 'blog')
      within("#category_#{category1.id}") do
        page.should have_selector('td', text: '0')
      end
      within("#category_#{category2.id}") do
        page.should have_selector('td', text: '1')
      end
    end
  end

  describe 'sidebar list' do
    it 'should display a link for a category with posts' do
      category = Factory(:category, name: 'Sidebar')
      post = Factory(:post, category: category)
      visit blog_root_url(subdomain: 'blog')
      page.should have_link('Sidebar')
    end

    it 'should not display a link for an empty category' do
      category = Factory(:category, name: 'Empty')
      visit blog_root_url(subdomain: 'blog')
      page.should_not have_link('Empty')
    end
  end

  it 'should show posts for the category' do
    category = Factory(:category, name: 'Sweet Stuff')
    post = Factory(:post, title: 'Super Sweet', category: category)
    visit blog_category_url(category, subdomain: 'blog')
    page.should have_content('Super Sweet')
  end

  context 'as a guest' do
    it 'should prevent access to editing a category' do
      category = Factory(:category, name: 'Blocked')
      lambda { visit edit_blog_category_url(category, subdomain: 'blog') }.should raise_error(Exceptions::PermissionDenied)
    end
  end

  context 'as an admin' do
    let(:admin) { Factory(:admin) }
    before do
      login_as admin 
    end

    describe 'creating a category' do
      it 'should prevent invalid input' do
        visit blog_posts_url(subdomain: 'blog')
        click_on 'New Category'
        click_on 'Create'
        page.should have_content("Name can't be blank")
      end

      it 'should redirect to the category on creation' do
        visit blog_posts_url(subdomain: 'blog')
        click_on 'New Category'
        fill_in 'Name', with: 'Cool Stuff'
        click_on 'Create'
        page.current_path.should eq('/categories/cool-stuff')
      end
    end

    describe 'editing a category' do
      let!(:category) { Factory(:category, name: 'Editable') }
      it 'should prevent invalid input' do
        visit blog_categories_url(subdomain: 'blog')
        within("#category_#{category.id}") do
          click_on "Edit"
        end
        fill_in 'Name', with: ''
        click_on 'Update'
        page.should have_content("Name can't be blank")
      end

      it 'should redirect to the category after update' do
        visit blog_categories_url(subdomain: 'blog')
        within("#category_#{category.id}") do
          click_on "Edit"
        end
        fill_in 'Name', with: 'Edited'
        click_on 'Update'
        page.current_path.should eq('/categories/editable')
      end
    end

    describe 'deleting a category' do
      it 'should show an error on the listing page if deletion failed' do
        category = Factory(:category, name: 'Save Me')
        post = Factory(:post, category: category)
        visit blog_categories_url(subdomain: 'blog')
        within("#category_#{category.id}") do
          click_on 'Delete'
        end
        page.current_path.should eq('/categories/save-me')
        page.should have_content('Cannot delete a category that has associated posts.')
      end

      it 'should redirect to the category listing' do
        category = Factory(:category, name: 'You Are So Dead')
        visit blog_categories_url(subdomain: 'blog')
        within("#category_#{category.id}") do
          click_on 'Delete'
        end
        page.current_url.should eq('http://blog.example.com/categories')
      end
    end
  end
end
