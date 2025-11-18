require 'rails_helper'

RSpec.describe "reminders/edit", type: :view do
  let(:reminder) {
    create :reminder
  }

  before(:each) do
    assign(:reminder, reminder)
  end

  it "renders the edit reminder form" do
    render

    assert_select "form[action=?][method=?]", reminder_path(reminder), "post" do

      assert_select "input[name=?]", "reminder[title]"

      assert_select "textarea[name=?]", "reminder[description]"

      assert_select "input[name=?]", "reminder[price]"

      assert_select "select[name=?]", "reminder[recurrence]"
    end
  end
end
