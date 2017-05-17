require_relative 'feature_helper'

context 'non logged in user' do
  it 'shows an index of comics on website' do
    visit '/'
    expect(page).to have_content('All Pages')
  end

  it 'gives user the option to login' do
    visit '/login'
    expect(page).to have_content('Username')
  end

  it 'has a login link on the main page' do
    visit '/'
    expect(page).to have_content('Login')
  end

  it 'allows user to view individual pages of a comic' do
    visit '/'
    first('.page > a').click
    expect(page).to have_selector('#page')
  end
end

context 'logged in user' do
  before(:all) do
    register_user('Frodo Baggins', 'frodolives', 'th30n3r1ng')
    # log_in_user('frodolives', 'th30n3r1ng')
  end
  it 'shows an index of comics on website' do
    visit '/'
    expect(page).to have_content('All Pages')
  end

  it 'shows page menu on layout' do
    visit '/'
    within('nav') do
      expect(page).to have_content('Pages')
    end
  end

  it 'allows user to add comics' do
    visit '/'
    page_count = all('.page').count
    visit '/pages/new'
    expect(page).to have_content('Add New Page')
    within 'form' do
      attach_file 'page_img', File.expand_path('spec/assets/happy.jpg')
    end
    click_on 'Add New Page'
    expect(all('.page').count).to eq page_count + 1
  end

  it 'allows user to delete comics' do
    visit '/'
    page_count = all('.page').count
    expect(page).to have_content('Delete Page')
    first('.delete-button').click
    expect(all('.page').count).to eq page_count - 1
  end
end
