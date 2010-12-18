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
  # Only possible in ActiveRecord 3.0
  require 'active_support/time'
rescue LoadError
  # Presume ActiveRecord 2.x
  # Require the whole lot of active_support
  # (It's not worth the effort to cherry pick the time components)
  require 'active_support'
end


class BeginningOfFortnight
  #
  # Fortnights are specified so that the reference date is in the first week of a fortnight.
  # This is just in case you want to be explicit about when fortnight start.
  # Eg, BeginningOfFortnight.reference_date = some_date
  #
  # (Considered using cattr_accessor here)
  #
  # (Is this a sensible idiom this type of setting?)
  #
  def self.reference_date
    @@reference ||= Time.at(0)
  end

  def self.reference_date=(new_reference_date)
    puts new_reference_date
    @@reference = new_reference_date
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
    # How many weeks since the beginning_of_week before unix time zero
    # (We just need a reference date. Probably any arbitrary time would work just as well).
    weeks_since_reference = ((self - BeginningOfFortnight.reference_date.beginning_of_week) / 1.week).to_i

    puts "weeks_since_reference: #{weeks_since_reference}"

    # When there's even number of weeks since epoch use beginning of this week,
    # odd number use beginning of last week
    #
    # The choice of which week should begin a fortnight is arbitrary (as far as I know)
    # If we change even to odd below then it would be flipped.
    #
    # Does it work for negative weeks_since_reference? Better write some tests.. :)
    #
    (weeks_since_reference.even? ? self : self - 1.week).beginning_of_week
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


