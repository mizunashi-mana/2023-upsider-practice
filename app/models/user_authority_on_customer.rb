class UserAuthorityOnCustomer < ApplicationRecord
  validates :customer, presence: true
  belongs_to :customer, class_name: "Customer"

  validates :user, presence: true
  belongs_to :user, class_name: "User"

  validates :authority_type, presence: true
  enum :authority_type, { operator: 0, viewer: 1, }, validate: true

  store :others, coder: JSON,
    accessors: [
      :authority_type,
    ]
  encrypts :others
end
