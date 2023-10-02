class User < ApplicationRecord
  has_secure_password

  validates :organization, presence: true
  belongs_to :organization, class_name: 'Organization'

  validates :email, uniqueness: true, presence: true, length: { maximum: 120 }
  encrypts :email, deterministic: true, downcase: true

  validates :authority_type_on_organization, presence: true
  enum :authority_type_on_organization, { admin: 0, member: 1, }, validate: true

  store :authority_on_organization, coder: JSON,
    accessors: [
      :authority_type_on_organization,
    ]
  encrypts :authority_on_organization

  has_many :user_authority_on_customers
end

module User::AuthorityOnOrganization
  ADMIN = 0
  MEMBER = 1
end
