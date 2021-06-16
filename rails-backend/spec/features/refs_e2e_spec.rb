require 'capybara/rspec'


RSpec.describe 'References on user interface testing: ', type: :feature, js: true do
  it 'creating reference' do
    visit 'http://rails:3000/conf'

    expect(page).to   have_content('Конфигуратор')
    expect(page).to   have_content('Справочники')
  end
end
