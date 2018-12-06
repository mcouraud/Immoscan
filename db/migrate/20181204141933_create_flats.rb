class CreateFlats < ActiveRecord::Migration[5.2]
  def change
    create_table :flats do |t|
      t.string :address
      t.string :city
      t.string :zipcode
      t.string :full_address
      t.string :surface_housing
      t.string :surface_ground
      t.string :nb_rooms
      t.string :nb_bedrooms
      t.string :price
      t.string :rent_or_buy
      t.text Array :photos
      t.text :description
      t.string :furnished
      t.string :type_advert
      t.string :website_source
      t.string :ad_url

      t.timestamps
    end
  end
end
