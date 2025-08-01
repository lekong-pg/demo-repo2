dict set map abc 123
puts $map
dict set map def 456
puts $map

puts "to get value of each key"
foreach item [dict keys $map] {
	set carry [dict get $map $item]
	puts $carry
}

puts "\nto retrive the keys"
set k [dict keys $map]
puts $k

puts "\nto detect each key if exist"
set r [dict exists $map def]
puts "def exist? $r"
set r [dict exist $map xyz]
puts "xyz exist? $r"
set r [dict exists $map 123]
puts "123 exist? $r"

puts "\nto insert 123 as keys"
set map [dict create 123 "ghi"]
puts "[dict keys $map]"

puts "\n Oops... need to add back the missing keys"
set map [dict append map abc 123 def 456]
puts "[dict keys $map]"

puts "\noops! need to append a list of keys"
set map [dict merge $map [dict create \
	abc 123 \
	def 456 \
	ghi 789]]
puts "[dict keys $map]"
