class Citizen < ApplicationRecord
  belongs_to :category
  has_many :messages, dependent: :destroy

  DEFAULT_NAME = "Unknown citizen"
end
