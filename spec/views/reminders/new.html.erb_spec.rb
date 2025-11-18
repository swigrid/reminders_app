require 'rails_helper'

RSpec.describe "reminders/new", type: :view do
  before(:each) do
    assign(:reminder, build(:reminder,
      title: "MyString",
      description: "MyString",
      price: "9.99",
      recurrence: "monthly"
    ))
  end

  it "renders new reminder form" do
    render

    assert_select "form[action=?][method=?]", reminders_path, "post" do

      assert_select "input[name=?]", "reminder[title]"

      assert_select "textarea[name=?]", "reminder[description]"

      assert_select "input[name=?]", "reminder[price]"

      assert_select "select[name=?]", "reminder[recurrence]"
    end
  end
end
