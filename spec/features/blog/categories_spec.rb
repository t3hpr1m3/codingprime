require 'spec_helper'

describe Blog::CategoriesController do
  describe 'category listing' do
    it 'should list categories' do
      category = create(:category)
      visit blog_categories_url(subdomain: 'blog')
      expect(page).to have_selector('td', text: category.slug)
    end

    it 'should show the post count' do
      category1 = create(:category, name: 'Empty')
      category2 = create(:category, name: 'Full')
      post = create(:post, category: category2)
      visit blog_categories_url(subdomain: 'blog')
      within("#category_#{category1.id}") do
        expect(page).to have_selector('td', text: '0')
      end
      within("#category_#{category2.id}") do
        expect(page).to have_selector('td', text: '1')
      end
    end
  end

  describe 'sidebar list' do
    it 'should display a link for a category with posts' do
      category = create(:category, name: 'Sidebar')
      post = create(:post, category: category)
      visit blog_root_url(subdomain: 'blog')
      expect(page).to have_link('Sidebar')
    end

    it 'should not display a link for an empty category' do
      category = create(:category, name: 'Empty')
      visit blog_root_url(subdomain: 'blog')
      expect(page).to_not have_link('Empty')
    end
  end

  it 'should show posts for the category' do
    category = create(:category, name: 'Sweet Stuff')
    post = create(:post, title: 'Super Sweet', category: category)
    visit blog_category_url(category, subdomain: 'blog')
    expect(page).to have_content('Super Sweet')
  end

  context 'as a guest' do
    it 'should prevent access to editing a category' do
      category = create(:category, name: 'Blocked')
      expect { visit edit_blog_category_url(category, subdomain: 'blog') }.to raise_error(Exceptions::PermissionDenied)
    end
  end

  context 'as an admin' do
    let(:admin) { create(:admin) }
    before do
      login_as admin 
    end

    describe 'creating a category' do
      it 'should prevent invalid input' do
        visit blog_posts_url(subdomain: 'blog')
        click_on 'New Category'
        click_on 'Create'
        expect(page).to have_content("Name can't be blank")
      end

      it 'should redirect to the category on creation' do
        visit blog_posts_url(subdomain: 'blog')
        click_on 'New Category'
        fill_in 'Name', with: 'Cool Stuff'
        click_on 'Create'
        expect(page.current_path).to eq('/categories/cool-stuff')
      end
    end

    describe 'editing a category' do
      let!(:category) { create(:category, name: 'Editable') }
      it 'should prevent invalid input' do
        visit blog_categories_url(subdomain: 'blog')
        within("#category_#{category.id}") do
          click_on "Edit"
        end
        fill_in 'Name', with: ''
        click_on 'Update'
        expect(page).to have_content("Name can't be blank")
      end

      it 'should redirect to the category after update' do
        visit blog_categories_url(subdomain: 'blog')
        within("#category_#{category.id}") do
          click_on "Edit"
        end
        fill_in 'Name', with: 'Edited'
        click_on 'Update'
        expect(page.current_path).to eq('/categories/editable')
      end
    end

    describe 'deleting a category' do
      it 'should show an error on the listing page if deletion failed' do
        category = create(:category, name: 'Save Me')
        post = create(:post, category: category)
        visit blog_categories_url(subdomain: 'blog')
        within("#category_#{category.id}") do
          click_on 'Delete'
        end
        expect(page.current_path).to eq('/categories/save-me')
        expect(page).to have_content('Cannot delete a category that has associated posts.')
      end

      it 'should redirect to the category listing' do
        category = create(:category, name: 'You Are So Dead')
        visit blog_categories_url(subdomain: 'blog')
        within("#category_#{category.id}") do
          click_on 'Delete'
        end
        expect(page.current_url).to eq('http://blog.example.com/categories')
      end
    end
  end
end
