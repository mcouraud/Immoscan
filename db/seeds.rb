# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Flat.destroy_all

flat_marseille = Flat.create([{city: "Marseille", address: "21 rue berlioz", price: 400, nb_rooms: 3, rent_or_buy: "louer"}, {city: "Marseille", address: "137 rue de rome", price: 300, nb_rooms: 2, rent_or_buy: "louer"}, {city: "Marseille", address: "7 rue crudère", price: 200000, nb_rooms: 3, rent_or_buy: "acheter"}])

flat_lyon = Flat.create([{city: "Lyon", address: "95 boulevard de la croix rousse"}, {city: "Lyon", address: "252 rue andré philip"}])
