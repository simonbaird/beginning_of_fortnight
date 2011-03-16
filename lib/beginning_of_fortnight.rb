#
# Author:: Simon Baird
# Email:: simon.baird@gmail.com
# Source:: https://github.com/simonbaird/beginning_of_fortnight
# License:: 'BSD-new' where the copyright holder is Simon Baird
#
# Extends ActiveSupport to provide these methods for Time and Date objects:
# * beginning_of_fortnight
# * end_of_fortnight
# * next_fortnight
#
# These methods should work similarly to beginning_of_week, end_of_week and next_week.
#
# This gem requires that you have a version of activesupport that defines beginning_of_week.
#
# =Installation
#
#    sudo gem install beginning_of_fortnight
#
# =Usage
#
# ===Basic usage
#
#    require 'rubygems'
#    require 'beginning_of_fortnight'
#
#    now = Time.now
#    puts now.beginning_of_fortnight
#    puts now.end_of_fortnight
#
# ===Explicitly setting a reference date
#
#    require 'rubygems'
#    require 'beginning_of_fortnight'
#
#    now = Time.now
#
#    # Globally define fortnights such that this date is the first half of a fortnight
#    ref_date = Time.parse('13-Oct-2010')
#    BeginningOfFortnight.reference_date = ref_date
#
#    puts now.beginning_of_fortnight # uses ref_date
#
#    # Change your mind...
#    BeginningOfFortnight.reference_date = Time.parse('20-Oct-2010')
#    puts now.beginning_of_fortnight # should be different
#
#    # You can also pass in a single use reference date if you want to mix it up
#    other_ref_date = Time.parse('27-Oct-2010')
#    puts now.beginning_of_fortnight(other_ref_date)
#
#

begin
  # Try to load just the time components
  # (Only possible in ActiveRecord 3.0)
  require 'active_support/time'
rescue LoadError
  # Presume we must have ActiveRecord 2.x so require the whole lot of active_support
  # (Decided it's not worth the effort to try to cherry pick just the time components)
  require 'active_support'
end

#
# Just a namespace and an accessor for the reference
# date used to define fortnight boundaries.
#
#--
# (Maybe this could use cattr_accessor. Not sure if it's worth it).
#++
#
module BeginningOfFortnight
  #
  # Fairly arbitrary choice of reference date
  #
  DEFAULT_REF_DATE = Time.at(0)

  #
  # Provide an accessor for @@reference_date. Uses the default value if not set.
  #
  def self.reference_date
    (@@reference_date ||= DEFAULT_REF_DATE).to_time
  end

  #
  # The 'reference_date' here is used to define where the fortnight boundary should be.
  # The way it works is that the reference_date is specified such that it falls in the first
  # half of the fortnightly period.
  #
  # You can just ignore this it will use a default value but if you want to be explicit then
  # set a date, for example:
  #
  #   # Define fortnight boundary
  #   BeginningOfFortnight.reference_date = Time.parse('13-Oct-2010')
  #
  #   # A date should work also
  #   BeginningOfFortnight.reference_date = Date.new(2010,10,13)
  #
  def self.reference_date=(reference_date)
    @@reference_date = reference_date
  end
end


#
# These methods should work similar to beginning_of_week and friends.
#
# In all these methods, if the optional argument <tt>reference_date</tt>
# is not given then the default reference date is used. See
# BeginningOfFortnight#reference_date.
#
# reference_date can be a Date or a Time object.
#
#--
# ActiveRecord 2.x puts these methods in a big long name space,
# ie ActiveSupport::CoreExtensions::Time::Calculations
# ActiveSupport 3.x just adds methods directly to Time.
# Will try the 3.x approach and hopefully it will work okay in 2.x also.
#++
#
class Time
  #
  # The beginning of the fortnight.
  #
  def beginning_of_fortnight(reference_date=nil)
    # Can pass in a reference date, otherwise use the configured default
    reference_date ||= BeginningOfFortnight.reference_date

    # The to_time is in case reference_date is passed in as a Date object
    reference_week = reference_date.to_time.beginning_of_week

    # How many weeks since reference week?
    weeks_since_reference = ((self - reference_week) / 1.week).to_i

    #
    # If the reference time is later than self, ie in the future,
    # then we flip the odd/even test here.
    #
    # Some explanation:
    #
    # In this diagram, '|' is a fortnight boundary, '+' is a week boundary and R is the reference week.
    #              R
    #  |  a  +  b  |  c  +  d  |
    #
    # The value of weeks_since_reference for dates at a, b, c and d is as follows:
    #  When self is earlier than reference_date:
    #   a (in first half) : -1, hence odd weeks_since_reference is in first half
    #   b (in second half):  0, hence even weeks_since_reference is in second half (because -0.5.to_i is 0 for example)
    #  When self is later than reference_date:
    #   c (in first half) :  0, hence even weeks_since_reference is in first half
    #   d (in second half):  1, hence odd weeks_since_reference is in second half
    #
    in_first_half = (reference_week > self ? weeks_since_reference.odd? : weeks_since_reference.even?)

    # The value of in_first_half decides which week to use
    (in_first_half ? self : self - 1.week).beginning_of_week
  end

  #
  # The end of the fortnight.
  #
  def end_of_fortnight(reference_date=nil)
    (beginning_of_fortnight(reference_date) + 1.week).end_of_week
  end

  #
  # The start of the fortnight after this one.
  #
  def next_fortnight(reference_date=nil)
    beginning_of_fortnight(reference_date) + 2.weeks
  end
end

#
# The Date methods are defined dynamically.
#
# See:
# * Time#beginning_of_fortnight
# * Time#end_of_fortnight
# * Time#next_fortnight
#
class Date
  # Going to be lazy here... in a good way (?)
  # Redoing the in_first_half logic for Date objects is not quite trivial
  [:beginning_of_fortnight, :end_of_fortnight, :next_fortnight].each do |method|
    define_method(method) do |*args|
      self.to_time.send(method,*args).to_date
    end
  end
end
