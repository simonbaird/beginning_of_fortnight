#
# Extend ActiveSupport to provide a beginning_of_fortnight and an
# end_of_fortnight method for the Time class
#
#
#


#
# ActiveRecord 2.xR 3.x I want to require only the time component
#
begin
  # Try to load just the time components
  # (Only possible in ActiveRecord 3.0)
  require 'active_support/time'
rescue LoadError
  # Presume ActiveRecord 2.x
  # Require the whole lot of active_support
  # (Decided it's not worth the effort to try to cherry pick just the time components)
  require 'active_support'
end


class BeginningOfFortnight
  #
  # Fortnights are specified so that the reference date is in the first week of a fortnight.
  # This is just in case you want to be explicit about when fortnight start.
  # Eg, BeginningOfFortnight.reference_week = some_date_in_that_week
  #
  # (Considered using cattr_accessor here)
  #
  # (Is this a sensible idiom this type of setting?)
  #
  DEFAULT_REF_DATE = Time.at(0)
  def self.reference_week
    (@@reference_date ||= DEFAULT_REF_DATE).beginning_of_week
  end

  def self.reference_date=(reference_date)
    @@reference_date = reference_date
  end

end



#
# AR 2.x uses ActiveSupport::CoreExtensions::Time::Calculations
# But AR 3.x just adds methods directly to Time
# Will try the 3.x approach and hopefully it will work in 2.x also.
#
class Time
  #
  # The beginning of the current fortnight
  #
  def beginning_of_fortnight
    # How many weeks since the beginning_of_week before the reference time?
    weeks_since_reference = ((self - BeginningOfFortnight.reference_week) / 1.week).to_i

    # If the reference time is later than self then we flip the odd/even test.
    # In this diagram, '|' is a fortnight boundary, '+' is a week boundary and R is the reference week
    # |  a  +  b  |R c  +  d  |
    # The value of weeks_since_reference for a, b, c and d is as follows:
    # a: -1, ie odd. b: 0, ie even.  c: 0, ie even. d: 1, ie odd
    in_first_half = (BeginningOfFortnight.reference_week > self ? weeks_since_reference.odd? : weeks_since_reference.even?)

    # in_first_half decides which week to use
    (in_first_half ? self : self - 1.week).beginning_of_week
  end

  #
  # The end of the current fortnight can be easily derived from the beginning like this
  #
  def end_of_fortnight
    (beginning_of_fortnight + 13.days).end_of_day
  end

  def next_fortnight
    (self + 1.fortnight).beginning_of_fortnight
  end
end


