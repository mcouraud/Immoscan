require 'dbf'


data = File.open('public/france2016.dbf')
widgets = DBF::Table.new(data)

widgets.each do |record|
  City.new(name: "#{record['NCC']}", ci:"#{record['DEP']}0#{record['COM']}")
end

Flat.destroy_all
