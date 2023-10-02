class Organization < ApplicationRecord
  validates :name, presence: true, length: { maximum: 120 }
  encrypts :name

  validates :representative_name, presence: true, length: { maximum: 120 }
  validates :contact_phone_number, presence: true, length: { maximum: 50 }
  validates :post_number, presence: true, length: { maximum: 50 }
  validates :address, presence: true, length: { maximum: 255 }

  store :others, coder: JSON,
    accessors: [
      :representative_name,
      :contact_phone_number,
      :post_number,
      :address,
    ]
  encrypts :others
end
