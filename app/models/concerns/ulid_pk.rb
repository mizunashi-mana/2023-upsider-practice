module UlidPk extend ActiveSupport::Concern
  included do
    attribute primary_key, :string, default: -> { ULID.generate }
  end
end
