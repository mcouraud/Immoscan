class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.string :search_url
      t.boolean :mail_alert
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
