#
# Extend ActiveSupport to provide a beginning_of_fortnight and an
# end_of_fortnight method for the Time class
#
#

# Sanity check?
raise "Can't find suitable ActiveSupport module" unless defined?(ActiveSupport::CoreExtensions::Time::Calculations)

module ActiveSupport::CoreExtensions::Time::Calculations
  #
  # How many weeks since the beginning_of_week before unix time zero
  #
  def weeks_after_epoch
    ((self - ::Time.at(0).beginning_of_week) / 1.week).to_i
  end

  #
  # The beginning of the current fortnight
  #
  # The choice of which week should begin a fortnight is arbitrary
  # If you want to flip it then change even? to odd? below
  #
  def beginning_of_fortnight
    # If there's been an even number of weeks since epoch use beginning of this week
    # If there's been an odd number of weeks since epoch use the beginning of last week
    (weeks_after_epoch.even? ? self : self - 1.week).beginning_of_week
  end

  #
  # The end of the current fortnight
  #
  def end_of_fortnight
    (beginning_of_fortnight + 13.days).end_of_day
  end
end
