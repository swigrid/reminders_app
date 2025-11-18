require 'rails_helper'

RSpec.describe "reminders/edit", type: :view do
  let(:reminder) {
    Reminder.create!(
      title: "MyString",
      description: "MyString",
      price: "9.99",
      recurrence: "MyString"
    )
  }

  before(:each) do
    assign(:reminder, reminder)
  end

  it "renders the edit reminder form" do
    render

    assert_select "form[action=?][method=?]", reminder_path(reminder), "post" do

      assert_select "input[name=?]", "reminder[title]"

      assert_select "input[name=?]", "reminder[description]"

      assert_select "input[name=?]", "reminder[price]"

      assert_select "input[name=?]", "reminder[recurrence]"
    end
  end
end
