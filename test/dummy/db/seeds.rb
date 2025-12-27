# unless Location.find_by(street: "Main Street")
#   locations = [ "Main Street", "Second Street", "Third Street", "Fourth Street", "Fifth Street", "Sixth Street", "Seventh Street", "Eighth Street", "Ninth Street", "Tenth Street" ]
#   cities = [ "Prague", "Berlin", "Warsaw", "New York", "Toronto", "Mexico City", "Sao Paulo", "Buenos Aires", "Canberra", "Wellington" ]
#   numbers = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]

#   locations.each do |location|
#     Location.create(street: location, city: cities.sample, number: numbers.sample)
#   end
#   puts "Seeded #{Location.count} locations"
# else
#   puts "Locations are already seeded."
# end

# unless School.find_by(name: "Muni")
#   schools = [ "Muni", "Cvut", "School of Science", "School of Arts", "School of Business", "School of Engineering", "School of Medicine", "School of Law", "School of Education", "School of Nursing" ]
#   capacities = [ 100, 101, 102, 103, 104, 105, 106, 107, 108, 109 ]

#   schools.each do |school_name|
#     School.create(name: school_name, capacity: capacities.sample, location: Location.all.sample)
#   end
#   puts "Seeded #{School.count} schools"
# else
#   puts "Schools are already seeded."
# end

# unless Student.find_by(name: "John")
#   names = [ "John", "Jane", "Jim", "Jill", "Jack", "Jill", "Jim", "Jane", "John", "Jill" ]
#   ages = [ 18, 19, 20, 21, 22, 23, 24, 25, 26, 27 ]

#   names.each do |name|
#     Student.create(name: name, age: ages.sample, credits: rand(30..180), school: School.all.sample)
#   end
#   puts "Seeded #{Student.count} students"
# else
#   puts "Students are already seeded."
# end
