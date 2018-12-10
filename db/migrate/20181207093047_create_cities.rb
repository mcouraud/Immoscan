class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :cp
      t.string :ci

      t.timestamps
    end
  end
end
