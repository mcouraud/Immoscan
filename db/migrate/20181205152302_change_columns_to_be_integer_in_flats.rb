class ChangeColumnsToBeIntegerInFlats < ActiveRecord::Migration[5.2]
  def change
    change_column :flats, :price, :integer, using: 'price::integer'
    change_column :flats, :surface_housing, :integer, using: 'surface_housing::integer'
    change_column :flats, :surface_ground, :integer, using: 'surface_ground::integer'
    change_column :flats, :nb_rooms, :integer, using: 'nb_rooms::integer'
    change_column :flats, :nb_bedrooms, :integer, using: 'nb_bedrooms::integer'
  end
end
