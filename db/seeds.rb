# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Reminder.destroy_all

50.times do
  created_at = Faker::Time.backward(days: 60)
  Reminder.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph,
    price: Faker::Number.decimal(l_digits: 2, r_digits: 2),
    recurrence: ["daily", "weekly", "monthly", nil].sample,
    remind_at: Faker::Time.forward(days: 30),
    created_at: created_at,
    updated_at: created_at
  )
end

puts "Created 50 reminders"
