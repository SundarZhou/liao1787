class Account < ApplicationRecord
  scope :normal, -> { where(is_normal: true) }
  scope :unnormal, -> { where(is_normal: false) }
end
