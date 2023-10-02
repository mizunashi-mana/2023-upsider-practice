class CustomerBankAccount < ApplicationRecord
  validates :owner_customer, presence: true
  belongs_to :owner_customer, class_name: "Customer"

  validates :name, presence: true, length: { maximum: 120 }
  encrypts :name

  validates :bank_name, presence: true, length: { maximum: 120 }
  validates :bank_branch_name, presence: true, length: { maximum: 120 }
  validates :account_number, presence: true, length: { maximum: 120 }

  store :others, coder: JSON,
    accessors: [
      :bank_name,
      :bank_branch_name,
      :account_number,
    ]
  encrypts :others
end
