require 'capybara/rspec'


RSpec.describe 'References on user interface testing: ', type: :feature, js: true do
  it 'should have necessary headers' do
    visit 'http://rails:3000/conf'

    expect(page).to   have_content('Конфигуратор')
    expect(page).to   have_content('Справочники')
  end

  it 'can create reference' do
    visit 'http://rails:3000/conf'

    click_link('add_ref')
    current_path.should == '/conf/refs/add'

    expect(page).to   have_content('Новый справочник')
    expect(page).to   have_content('Имя справочника:')
    page.fill_in 'ref_name', with: 'Test reference'

    expect(page).to   have_xpath("//table/thead/tr/th[1][text()[contains(.,'Имя поля')]]")
    expect(page).to   have_xpath("//table/thead/tr/th[2][text()[contains(.,'Тип поля')]]")
    expect(page).to   have_xpath("//table/thead/tr/th[3]")

    within(:xpath, "//table/tbody/tr[1]/td[1]") do
      fill_in 'field_name', :with => 'customer'
    end
    within(:xpath, "//table/tbody/tr[1]/td[2]") do
      select 'string', from: 'field_type', visible: :all
    end
    within(:xpath, "//table/tbody/tr[1]/td[3]") do
      click_button 'add_field'
    end

    within(:xpath, "//table/tbody/tr[2]/td[1]") do
      fill_in 'field_name', :with => 'amount'
    end
    within(:xpath, "//table/tbody/tr[1]/td[2]") do
      select 'number', from: 'field_type', visible: :all
    end
    within(:xpath, "//table/tbody/tr[2]/td[3]") do
      click_button 'add_field'
    end

    within(:xpath, "//table/tbody/tr[3]/td[1]") do
      fill_in 'field_name', :with => 'description'
    end
    within(:xpath, "//table/tbody/tr[1]/td[2]") do
      select 'text', from: 'field_type', visible: :all
    end

    page.click_button 'Сохранить'

    current_path.should == 'http://rails:3000/conf/refs'

    expect(page).to   have_content('Test reference')
  end
end
