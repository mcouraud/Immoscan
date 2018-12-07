require 'dbf'

data = File.open('public/france2016.dbf')
widgets = DBF::Table.new(data)

widgets.each do |record|
  City.new(name: "#{record['NCC']}", ci:"#{record['DEP']}0#{record['COM']}")
end

# Flat.destroy_all

# flat_marseille = Flat.create([{city: "Marseille", address: "21 rue berlioz", price: 400, nb_rooms: 3, rent_or_buy: "louer"}, {city: "Marseille", address: "137 rue de rome", price: 300, nb_rooms: 2, rent_or_buy: "louer"}, {city: "Marseille", address: "7 rue crudère", price: 200000, nb_rooms: 3, rent_or_buy: "acheter"}])

# flat_lyon = Flat.create([{city: "Lyon", address: "95 boulevard de la croix rousse"}, {city: "Lyon", address: "252 rue andré philip"}])

