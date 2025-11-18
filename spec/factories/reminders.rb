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
FactoryBot.define do
  factory :reminder do
    title { "MyString" }
    description { "MyString" }
    remind_at { "2025-11-18 13:22:37" }
    price { "9.99" }
    recurrence { "monthly" }
  end
end
