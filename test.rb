
require 'rubygems'
require 'active_support'
require 'beginning_of_fortnight'

now = Time.now

puts now.beginning_of_fortnight
puts now.end_of_fortnight

BeginningOfFortnight.reference_date = Time.at(0) + 7.days
puts now.beginning_of_fortnight
puts now.end_of_fortnight
