class Flat < ApplicationRecord

  has_many :favorites

  validates :city, presence: true
end
