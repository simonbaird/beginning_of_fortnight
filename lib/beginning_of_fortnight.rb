#
# Author: Simon Baird
#
# Extends ActiveSupport to provide {beginning_of_,end_of,next}_fortnight
# methods for Time and Date classes. Should work similarly to
# {beginning_of_,end_of,next}_week.
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
# Just a namespace and an accessor for the a reference
# date used to define fortnight boundaries.
#
# (Is this a sensible idiom this type of config?)
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
# ActiveRecord 2.x puts these methods in a big long name space,
# ie ActiveSupport::CoreExtensions::Time::Calculations
# ActiveSupport 3.x just adds methods directly to Time.
# Will try the 3.x approach and hopefully it will work okay in 2.x also.
#
class Time
  #
  # The beginning of the current fortnight
  #
  def beginning_of_fortnight(reference_date=nil)
    # Can pass in a reference date, otherwise use the configured default
    reference_date ||= BeginningOfFortnight.reference_date

    # The to_time is in case reference_date is passed in as a Date object
    reference_week = reference_date.to_time.beginning_of_week

    # How many weeks since reference week?
    weeks_since_reference = ((self - reference_week) / 1.week).to_i

    #
    # If the reference time is later than self then we flip the odd/even test.
    #
    # For example in this diagram, '|' is a fortnight boundary, '+' is a week boundary and R is the reference week
    # |  a  +  b  |R c  +  d  |
    #
    # The value of weeks_since_reference for a, b, c and d is as follows:
    #   a (in first half) : -1, ie odd
    #   b (in second half):  0, ie even
    #   c (in first half) :  0, ie even
    #   d (in second half):  1, ie odd
    #
    in_first_half = (reference_week > self ? weeks_since_reference.odd? : weeks_since_reference.even?)

    # The value of in_first_half decides which week to use
    (in_first_half ? self : self - 1.week).beginning_of_week
  end

  #
  # The end of the current fortnight can be derived from the beginning like this
  #
  def end_of_fortnight(reference_date=nil)
    (beginning_of_fortnight(reference_date) + 1.week).end_of_week
  end

  #
  # There is a next_week so let's make a next_fortnight as well
  #
  def next_fortnight(reference_date=nil)
    beginning_of_fortnight(reference_date) + 2.weeks
  end
end

class Date
  # Going to be lazy here...
  [:beginning_of_fortnight, :end_of_fortnight, :next_fortnight].each do |method|
    define_method(method) do |*args|
      self.to_time.send(method,*args).to_date
    end
  end
end
