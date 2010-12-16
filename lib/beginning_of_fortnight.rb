#
# Extend ActiveSupport to provide a beginning_of_fortnight and an
# end_of_fortnight method for the Time class
#
#

# Sanity check?
raise "Can't find suitable ActiveSupport module" unless defined?(ActiveSupport::CoreExtensions::Time::Calculations)

class BeginningOfFortnight
  #
  # Fortnights are specified so that the reference date is in the first week of a fortnight.
  # This is just in case you want to be explicit about when fortnight start.
  # Eg, BeginningOfFortnight.reference_date = some_date
  #
  # (Maybe a better way to do this)
  #
  def self.reference_date
    @@reference ||= Time.at(0)
  end

  def self.reference_date=(new_reference_date)
    @@reference = new_reference_date
  end

end

module ActiveSupport::CoreExtensions::Time::Calculations
  #
  # The beginning of the current fortnight
  #
  def beginning_of_fortnight
    # How many weeks since the beginning_of_week before unix time zero
    # (We just need a reference date. Probably any arbitrary time would work just as well).
    weeks_since_reference = ((self - BeginningOfFortnight.reference_date.beginning_of_week) / 1.week).to_i

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

end
