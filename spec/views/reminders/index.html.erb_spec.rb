require 'rails_helper'

RSpec.describe 'reminders/index', type: :view do
  before(:each) do
    create(:reminder,
           title: 'Title',
           description: 'Description',
           price: '9.99',
           recurrence: 'monthly')
    create(:reminder,
           title: 'Title',
           description: 'Description',
           price: '9.99',
           recurrence: 'monthly')

    assign(:due_reminders, Reminder.all)
    assign(:reminders, Reminder.all.page(1))
  end

  it 'renders a list of reminders' do
    render
    assert_select 'div.col-12', text: Regexp.new('Title'), count: 4
    assert_select 'div.col-12', text: Regexp.new('Description'), count: 4
    assert_select 'div.col-4', text: Regexp.new('9.99'), count: 4
    assert_select 'div.col-4', text: Regexp.new('Recurrence'), count: 4
  end
end
