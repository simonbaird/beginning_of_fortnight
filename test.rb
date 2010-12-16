
require 'rubygems'
require 'active_support'
require 'beginning_of_fortnight'

now = Time.now

puts now.beginning_of_fortnight
puts now.end_of_fortnight
puts now.end_of_month.beginning_of_fortnight
puts now.end_of_month.end_of_fortnight
