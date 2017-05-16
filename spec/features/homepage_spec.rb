require_relative 'feature_helper'

context 'non logged in user' do
  it 'shows an index of comics on website' do
    visit '/'
    expect(page).to have_content('All Pages')
  end

  it 'gives user the option to login' do
    visit '/login'
    expect(page).to have_content('enter username:')
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
    # login user
  end
  it 'shows an index of comics on website' do
    visit '/'
    expect(page).to have_content('All Comics')
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
    fill_in 'page_img', with: File.expand_path('../assets/happy.jpg')
    click_on 'Add New Page'
    expect(all('.page').count).to eq page_count + 1
  end
end
