class RemindersDueService
  def initialize(reminders)
    @reminders = reminders
  end

  def call
    @reminders
      # daily reminders: list all reminders due today and in the past (don't remind today's date today)
      .where(recurrence: nil)
      .where(
        'remind_at >= ? AND remind_at <= ?',
        Time.current.beginning_of_day,
        Time.current.end_of_day
      )
      # list all reminders due today with no recurrence
      .or(
        @reminders.where(recurrence: 'daily').where(
          'remind_at <= ?',
          Time.current.end_of_day
        )
      )
      # list all reminder due today with weekly recurrence wday of week match and date in past
      .or(
        @reminders.where(recurrence: 'weekly').where(
          'remind_at <= ?',
          Time.current.end_of_day
        )
        .where(
          'EXTRACT(DOW FROM remind_at) = ?',
          Time.current.wday
        )
      )
      # list all reminder due today with monthly recurrence day of month match and date in past
      .or(
        @reminders.where(recurrence: 'monthly').where(
          'remind_at <= ?',
          Time.current.end_of_day
        ).where(
          'EXTRACT(DAY FROM remind_at) = ?',
          Time.current.day
        )
      )
  end
end
