require 'rails_helper'

RSpec.describe "reminders/index", type: :view do
  

  before(:each) do
    create(:reminder,
        title: "Title",
        description: "Description",
        price: "9.99",
        recurrence: "monthly"
      )
      create(:reminder,
        title: "Title",
        description: "Description",
        price: "9.99",
        recurrence: "monthly"
      )

    assign(:reminders, Reminder.all.page(1))
  end

  it "renders a list of reminders" do
    render
    assert_select "div.col-12", text: Regexp.new("Title".to_s), count: 2
    assert_select "div.col-12", text: Regexp.new("Description".to_s), count: 2
    assert_select "div.col-4", text: Regexp.new("9.99".to_s), count: 2
    assert_select "div.col-4", text: Regexp.new("Recurrence".to_s), count: 2
  end
end
