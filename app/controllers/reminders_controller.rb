class RemindersController < ApplicationController
  before_action :set_reminder, only: %i[show edit update destroy]

  # GET /reminders
  def index
    @due_reminders = RemindersDueService.new(Reminder.all).call
    @reminders = Reminder.created_at_desc.page(params[:page]).per(10)
  end

  # GET /reminders/1
  def show
  end

  # GET /reminders/new
  def new
    @reminder = Reminder.new
  end

  # GET /reminders/1/edit
  def edit
  end

  # POST /reminders
  def create
    @reminder = Reminder.new(reminder_params)

    if @reminder.save
      redirect_to @reminder, notice: 'Reminder was successfully created.'
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /reminders/1
  def update
    if @reminder.update(reminder_params)
      redirect_to @reminder, notice: 'Reminder was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /reminders/1
  def destroy
    @reminder.destroy!
    redirect_to reminders_url, notice: 'Reminder was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reminder
    @reminder = Reminder.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def reminder_params
    params.require(:reminder).permit(:title, :description, :remind_at, :price, :recurrence)
  end
end
