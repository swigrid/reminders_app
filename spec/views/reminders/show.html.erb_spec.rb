require 'rails_helper'

RSpec.describe "reminders/show", type: :view do
  before(:each) do
    assign(:reminder, create(:reminder,
      title: "Title",
      description: "Description",
      price: "9.99",
      recurrence: "monthly"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Recurrence/)
  end
end
