# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts 'Deleting existing reminders...'
Reminder.destroy_all

reminders_to_create = 150

puts "Creating #{reminders_to_create} reminders..."
reminders_to_create.times do
  created_at = Faker::Time.backward(days: 60)
  reminder = Reminder.new(
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph,
    price: Faker::Number.decimal(l_digits: 2, r_digits: 2),
    recurrence: ['daily', 'weekly', 'monthly', nil].sample,
    remind_at: [Faker::Time.backward(days: 30), Faker::Time.forward(days: 30)].sample,
    created_at: created_at,
    updated_at: created_at
  )
  reminder.save(validate: false)
end

puts "Created #{Reminder.count} reminders'"
