class RemindersDueService
  def initialize(reminders)
    @reminders = reminders
  end

  def call
    @reminders
      # daily reminders: list all reminders due today and in the past (don't remind today's date today)
      .where(recurrence: nil)
      .where('remind_at >= ? AND remind_at <= ?', Time.current.beginning_of_day, Time.current.end_of_day)
      .or(
        # list all reminders due today with no recurrence
        @reminders.where(recurrence: 'daily').where('remind_at <= ?', Time.current.end_of_day)
      )
      .or(
        # list all reminder due today with weekly recurrence wday of week match and date in past
        @reminders.where(recurrence: 'weekly').where('remind_at <= ?', Time.current.end_of_day)
                  .where('EXTRACT(DOW FROM remind_at) = ?', Time.current.wday)
      )
      .or(
        # list all reminder due today with monthly recurrence day of month match and date in past
        @reminders.where(recurrence: 'monthly')
                  .where('remind_at <= ?', Time.current.end_of_day)
                  .where(monthly_edge_case_condition)
      )
  end

  private

  def monthly_edge_case_condition
    if edge_case_february?
      # February 28th, 29th
      #
      # if feb 29th
      #  -> get reminders 29, 30, 31
      # if feb 28 is last day in the month
      #  -> get reminders 28, 29, 30, 31
      if Time.current.day == 29
        ['EXTRACT(DAY FROM remind_at) = ? OR EXTRACT(DAY FROM remind_at) = ? OR EXTRACT(DAY FROM remind_at) = ?', 29,
         30, 31]
      else
        [
          'EXTRACT(DAY FROM remind_at) = ? OR EXTRACT(DAY FROM remind_at) = ? OR EXTRACT(DAY FROM remind_at) = ? OR EXTRACT(DAY FROM remind_at) = ?', 28, 29, 30, 31
        ]
      end
    elsif last_day_of_month_edge_case?
      # when today is 30th and tomorrow is 1st of next month, include reminders set for 31st
      ['EXTRACT(DAY FROM remind_at) = ? OR EXTRACT(DAY FROM remind_at) = ?', Time.current.day, 31]
    else
      # regular condition
      ['EXTRACT(DAY FROM remind_at) = ?', Time.current.day]
    end
  end

  # Check for end of month edge case
  def last_day_of_month_edge_case?
    # Check if today is the 30th and tomorrow is the first of the next month
    Time.current.day == 30 && (Time.current + 1.day).month != Time.current.month
  end

  # Check for February edge case
  def edge_case_february?
    Time.current.month == 2 && [28, 29].include?(Time.current.day) &&
      (Time.current + 1.day).month != Time.current.month
  end
end
