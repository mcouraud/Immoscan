class Flat < ApplicationRecord

  def initialize(attributes)
    super
    @price = attributes[:price].to_i
  end

  has_many :favorites

  validates :city, presence: true
end
