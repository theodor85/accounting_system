require 'capybara/rspec'


RSpec.describe 'References on user interface testing: ', type: :feature, js: true do
  it 'should have necessary headers' do
    visit 'http://rails:3000/conf'

    expect(page).to   have_content('Конфигуратор')
    expect(page).to   have_content('Справочники')
  end

  it 'can create reference' do
    visit 'http://rails:3000/conf'

    # до нажатия нет полей для справочника
    expect(page.has_xpath?("//div[@id='new_ref']")).to be false

    find_button('add_ref').click
    # # появляются поля для ввода параметров справочника
    expect(page.has_xpath?("//div[@id='new_ref']")).to be true
    expect(page).to   have_content('Новый справочник')
    expect(page).to   have_content('Имя справочника:')
    page.fill_in 'ref_name', with: 'Test reference'

    expect(page).to   have_content('Имя поля:')
    page.fill_in 'field_name', with: 'customer'
  
    expect(page).to   have_content('Тип поля:')
    page.fill_in 'field_type', with: 'string'

    expect(page).to   have_link('Добавить')

    page.click_button 'Сохранить'

    expect(page).to   have_content('Test reference')
  end
end
