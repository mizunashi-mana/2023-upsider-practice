class Invoice < ApplicationRecord
  validates :issued_customer, presence: true
  belongs_to :issued_customer, class_name: "Customer"

  validates :status, presence: true
  enum :status, { unprocessed: 0, in_progress: 1, payed: 2, error: 3 }, validate: true

  def public_status
    case status
    when 'unprocessed', 'in_progress', 'error' then
      # DISCUSSION: 'error' means 'The inputs from the user are wrong!', or system error?
      :unpayed
    when 'payed' then
      :payed
    else raise RuntimeError, "Unreachable: unknown type #{status}"
    end
  end

  validates :issued_date, presence: true
  validates :payment_due_date, presence: true
  validates :payment_amount_jpy,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
    }
  validates :claimed_amount_jpy,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
    }

  validates :transaction_fee_jpy, presence: true
  validates :transaction_fee_ratio, presence: true
  validates :transaction_fee_tax_jpy, presence: true
  validates :transaction_fee_tax_ratio, presence: true

  store :others, coder: JSON,
    accessors: [
      :transaction_fee_jpy,
      :transaction_fee_ratio,
      :transaction_fee_tax_jpy,
      :transaction_fee_tax_ratio,
    ]
  encrypts :others
end
