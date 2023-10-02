module PaymentActions extend ActiveSupport::Concern
  PAYMENT_GRACE_DAYS = 3
  def validate_payable_due_date(due_date, current_date)
    current_date <= due_date.prev_day(PAYMENT_GRACE_DAYS)
  end
end
