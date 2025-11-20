require 'rails_helper'

RSpec.describe RemindersDueService, type: :service do
  # freeze time to ensure consistent test results
  before(:each) do
    # travel to 1st of November 2025, 10:00 AM
    travel_to Time.zone.local(2025, 11, 1, 10, 0, 0)
  end

  after(:each) do
    travel_back
  end

  subject(:due_reminders) { described_class.new(Reminder.all).call }

  # verify we traveled correctly
  it 'freezes time correctly' do
    # 1st November 2025, 10:00 AM
    expect(Time.current.to_i).to eq(Time.zone.local(2025, 11, 1, 10, 0, 0).to_i)
  end

  # ==============================================
  # reminders with no recurrence
  let!(:reminder_yesterday) { create(:reminder, title: 'Past Reminder', remind_at: 1.day.ago, recurrence: nil) }
  let!(:reminder_today) { create(:reminder, title: 'Past Reminder', remind_at: Time.current, recurrence: nil) }
  let!(:reminder_tomorrow) { create(:reminder, title: 'Future Reminder', remind_at: 1.day.from_now, recurrence: nil) }

  # ==============================================
  # reminders with recurrence every day
  let!(:recurring_daily_reminder_yesterday) do
    create(:reminder, title: 'Recurring Past Reminder', remind_at: 1.day.ago, recurrence: 'daily')
  end
  let!(:recurring_daily_reminder_today) do
    create(:reminder, title: 'Recurring Today Reminder', remind_at: Time.current, recurrence: 'daily')
  end
  let!(:recurring_daily_reminder_tomorrow) do
    create(:reminder, title: 'Recurring Future Reminder', remind_at: 1.day.from_now, recurrence: 'daily')
  end

  # ==============================================
  # reminders with recurrence every week
  let!(:recurring_weekly_reminder_last_week) do
    create(:reminder,
           title: 'Recurring Weekly Past Reminder', remind_at: 7.days.ago, recurrence: 'weekly')
  end
  let!(:recurring_weekly_reminder_last_week_plus_one_day) do
    create(:reminder,
           title: 'Recurring Weekly Past Reminder Plus One Day', remind_at: 6.days.ago, recurrence: 'weekly')
  end
  # this week reminders
  let!(:recurring_weekly_reminder_today_yesterday) do
    create(:reminder, title: 'Recurring Weekly Today Reminder Yesterday', remind_at: 1.day.ago, recurrence: 'weekly')
  end
  let!(:recurring_weekly_reminder_today) do
    create(:reminder, title: 'Recurring Weekly Today Reminder',
                      remind_at: Time.current, recurrence: 'weekly')
  end
  let!(:recurring_weekly_reminder_tomorrow) do
    create(:reminder, title: 'Recurring Weekly Tomorrow Reminder', remind_at: 1.day.from_now, recurrence: 'weekly')
  end
  # future week reminders
  let!(:recurring_weekly_reminder_next_week_minus_one_day) do
    create(:reminder, title: 'Recurring Weekly Future Reminder Minus One Day', remind_at: 6.days.from_now,
                      recurrence: 'weekly')
  end
  let!(:recurring_weekly_reminder_next_week) do
    create(:reminder, title: 'Recurring Weekly Future Reminder',
                      remind_at: 7.days.from_now, recurrence: 'weekly')
  end
  let!(:recurring_weekly_reminder_next_week_plus_one_day) do
    create(:reminder, title: 'Recurring Weekly Future Reminder Plus One Day', remind_at: 8.days.from_now,
                      recurrence: 'weekly')
  end

  # ==============================================
  # reminders with monthly recurrence
  let!(:recurring_monthly_reminder_last_month_day_before) do
    create(:reminder,
           title: 'Recurring Monthly Past Reminder Day Before', remind_at: (1.months.ago + 1.day.ago),
           recurrence: 'monthly')
  end
  let!(:recurring_monthly_reminder_last_month) do
    create(:reminder,
           title: 'Recurring Monthly Past Reminder', remind_at: 1.month.ago, recurrence: 'monthly')
  end
  let!(:recurring_monthly_reminder_last_month_day_after) do
    create(:reminder, title: 'Recurring Monthly Past Reminder Day After', remind_at: (1.months.ago + 1.day.from_now),
                      recurrence: 'monthly')
  end

  # this month reminders
  let!(:recurring_monthly_reminder_this_month_day_before) do
    create(:reminder,
           title: 'Recurring Monthly This Month Reminder Day Before', remind_at: 1.day.ago, recurrence: 'monthly')
  end
  let!(:recurring_monthly_reminder_this_month) do
    create(:reminder, title: 'Recurring Monthly This Month Reminder', remind_at: Time.current, recurrence: 'monthly')
  end
  let!(:recurring_monthly_reminder_this_month_day_after) do
    create(:reminder,
           title: 'Recurring Monthly This Month Reminder Day After', remind_at: 1.day.from_now, recurrence: 'monthly')
  end

  # next month reminders
  let!(:recurring_monthly_reminder_next_month_day_before) do
    create(:reminder,
           title: 'Recurring Monthly Future Reminder Day Before', remind_at: (1.months.from_now + 1.day.ago),
           recurrence: 'monthly')
  end
  let!(:recurring_monthly_reminder_next_month) do
    create(:reminder, title: 'Recurring Monthly Future Reminder', remind_at: 1.month.from_now, recurrence: 'monthly')
  end
  let!(:recurring_monthly_reminder_next_month_day_after) do
    create(:reminder, title: 'Recurring Monthly Future Reminder Day After',
                      remind_at: (1.months.from_now + 1.day.from_now), recurrence: 'monthly')
  end

  context 'with no recurrence' do
    it 'returns todays reminders' do
      expect(due_reminders).to include(reminder_today)
    end

    it 'does not return past reminders' do
      expect(due_reminders).not_to include(reminder_yesterday)
    end

    it 'does not return future reminders' do
      expect(due_reminders).not_to include(reminder_tomorrow)
    end
  end

  context 'when recurrence is daily' do
    it 'returns yesterdays recurring daily reminder' do
      expect(due_reminders).to include(recurring_daily_reminder_yesterday)
    end

    it 'returns todays recurring daily reminder' do
      expect(due_reminders).to include(recurring_daily_reminder_today)
    end

    it 'does not return tomorrows recurring daily reminder' do
      expect(due_reminders).not_to include(recurring_daily_reminder_tomorrow)
    end
  end

  context 'when recurrence is weekly' do
    it 'returns last weeks recurring weekly reminder' do
      expect(due_reminders).to include(recurring_weekly_reminder_last_week)
    end

    it 'does not return last weeks plus one day recurring weekly reminder' do
      expect(due_reminders).not_to include(recurring_weekly_reminder_last_week_plus_one_day)
    end

    it 'does not return yesterday\'s recurring weekly reminder' do
      expect(due_reminders).not_to include(recurring_weekly_reminder_today_yesterday)
    end

    it 'returns todays recurring weekly reminder' do
      expect(due_reminders).to include(recurring_weekly_reminder_today)
    end

    it 'does not return tomorrows recurring weekly reminder' do
      expect(due_reminders).not_to include(recurring_weekly_reminder_tomorrow)
    end

    it 'does not return next weeks minus one day recurring weekly reminder' do
      expect(due_reminders).not_to include(recurring_weekly_reminder_next_week_minus_one_day)
    end

    it 'does not return next weeks recurring weekly reminder' do
      expect(due_reminders).not_to include(recurring_weekly_reminder_next_week)
    end

    it 'does not return next weeks plus one day recurring weekly reminder' do
      expect(due_reminders).not_to include(recurring_weekly_reminder_next_week_plus_one_day)
    end
  end

  context 'when recurrence is monthly' do
    it 'does not return last months recurring monthly reminder day before' do
      expect(due_reminders).not_to include(recurring_monthly_reminder_last_month_day_before)
    end

    it 'returns last months recurring monthly reminder' do
      expect(due_reminders).to include(recurring_monthly_reminder_last_month)
    end

    it 'does not return last months recurring monthly reminder day after' do
      expect(due_reminders).not_to include(recurring_monthly_reminder_last_month_day_after)
    end

    it 'does not return this months recurring monthly reminder day before' do
      expect(due_reminders).not_to include(recurring_monthly_reminder_this_month_day_before)
    end

    it 'returns this months recurring monthly reminder' do
      expect(due_reminders).to include(recurring_monthly_reminder_this_month)
    end

    it 'does not return this months recurring monthly reminder day after' do
      expect(due_reminders).not_to include(recurring_monthly_reminder_this_month_day_after)
    end

    it 'does not return next months recurring monthly reminder day before' do
      expect(due_reminders).not_to include(recurring_monthly_reminder_next_month_day_before)
    end

    it 'does not return next months recurring monthly reminder' do
      expect(due_reminders).not_to include(recurring_monthly_reminder_next_month)
    end

    it 'does not return next months recurring monthly reminder day after' do
      expect(due_reminders).not_to include(recurring_monthly_reminder_next_month_day_after)
    end
  end
end
