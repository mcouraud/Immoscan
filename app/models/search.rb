class Search < ApplicationRecord
  belongs_to :user

  validates :mail_alert, :search_url, presence: true
end
