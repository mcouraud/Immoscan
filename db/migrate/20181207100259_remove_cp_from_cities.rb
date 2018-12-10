class RemoveCpFromCities < ActiveRecord::Migration[5.2]
  def change
    remove_column :cities, :cp, :string
  end
end
