class Winner < ApplicationRecord
  scope :active, -> { where(active: true) }
end
