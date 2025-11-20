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

  describe '#only_future_remind_at' do
    it 'is not valid if remind_at is in the past' do
      reminder.remind_at = 1.day.ago
      expect(reminder).not_to be_valid
      expect(reminder.errors[:remind_at]).to include('must be in the future')
    end

    it 'is valid if remind_at is in the future' do
      reminder.remind_at = 1.day.from_now
      expect(reminder).to be_valid
    end
  end

  describe 'scopes' do
    describe '.created_at_desc' do
      it 'orders reminders by latest first' do
        older_reminder = create(:reminder, created_at: 2.days.ago)
        newer_reminder = create(:reminder, created_at: 1.day.ago)

        expect(Reminder.created_at_desc.first).to eq(newer_reminder)
        expect(Reminder.created_at_desc.last).to eq(older_reminder)
      end
    end
  end
end
