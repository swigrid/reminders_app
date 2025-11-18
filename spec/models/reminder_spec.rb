# == Schema Information
#
# Table name: reminders
#
#  id          :bigint           not null, primary key
#  description :text
#  price       :decimal(10, 2)
#  recurrence  :string
#  remind_at   :datetime
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Reminder, type: :model do
  let(:reminder) { create(:reminder) }

  it 'should be valid with valid attributes' do
    expect(reminder).to be_valid
  end

  it 'is not valid without a title' do
    reminder.title = nil
    expect(reminder).not_to be_valid
  end

  it 'is not valid with a title longer than 255 characters' do
    reminder.title = 'a' * 256
    expect(reminder).not_to be_valid
  end

  it 'is not valid without a remind_at' do
    reminder.remind_at = nil
    expect(reminder).not_to be_valid
  end

  context 'price validations' do
    it 'is valid with a nil price' do
      reminder.price = nil
      expect(reminder).to be_valid
    end

    it 'is valid with a non-negative price' do
      reminder.price = 10.50
      expect(reminder).to be_valid
    end

    it 'is not valid with a negative price' do
      reminder.price = -5.00
      expect(reminder).not_to be_valid
    end

    it 'is not valid with a non-numeric price' do
      reminder.price = 'abc'
      expect(reminder).not_to be_valid
    end
  end
end
