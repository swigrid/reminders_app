class CreateReminders < ActiveRecord::Migration[7.1]
  def change
    create_table :reminders do |t|
      t.string :title
      t.string :description
      t.datetime :remind_at
      t.decimal :price, precision: 10, scale: 2
      t.string :recurrence

      t.timestamps
    end
  end
end
