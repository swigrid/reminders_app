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
class Reminder < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :remind_at, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :only_future_remind_at

  enum recurrence: { none: 'none', daily: 'daily', weekly: 'weekly', monthly: 'monthly' },
       _prefix: true

  scope :created_at_desc, -> { order(created_at: :desc) }

  private

  def only_future_remind_at
    return if remind_at.blank?

    errors.add(:remind_at, 'must be in the future') if remind_at < Time.current
  end
end
