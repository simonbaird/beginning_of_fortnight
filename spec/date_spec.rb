
require 'rubygems'
require 'beginning_of_fortnight'

describe Date, "#beginning_of_fortnight" do
  before :each do
    @now_date = Date.today

    # Just an arbitrary date that I can test with
    @test_date                 = Date.new(2010,12,17) # A Friday
    @test_date_plus_one_week   = Date.new(2010,12,24) # The following Friday
    @test_date_minus_one_week  = Date.new(2010,12,10) # The previous Friday

    # Weeks begin on Monday in ActiveSupport
    @test_date_start_week      = Date.new(2010,12,13) # The Monday before
    @test_date_start_prev_week = Date.new(2010,12,6)  # The Monday before that
    @test_date_start_next_week = Date.new(2010,12,20) # The Monday before that

    # Make sure it's reset back to use the default because some tests change this
    BeginningOfFortnight.reference_date = nil
  end

  it "returns a Date object" do
    [@now_date,@test_date].each do |d|
      d.beginning_of_fortnight .class .should == Date
      d.end_of_fortnight       .class .should == Date
      d.next_fortnight         .class .should == Date
    end
  end

  it "gives correct values for a test date with default reference" do
    # With default reference date
    # (With the default reference date, this date falls in the second week of a fornight)
    @test_date.beginning_of_fortnight .should == @test_date_start_prev_week
    @test_date.end_of_fortnight       .should == @test_date_start_prev_week + 13.days
    @test_date.next_fortnight         .should == @test_date_start_prev_week + 14.days
  end

  it "gives correct values for a test date with explict reference" do
    # Now explicitly set a reference date. Setting a reference date specifies that the given date
    # is in the first week of a fornight.
    BeginningOfFortnight.reference_date = @test_date
    @test_date.beginning_of_fortnight .should == @test_date_start_week

    # Now explicitly set another reference date. Should flip back to be same as the default.
    BeginningOfFortnight.reference_date = @test_date_plus_one_week
    @test_date.beginning_of_fortnight .should == @test_date_start_prev_week
  end

  it "works with a custom reference date given as an argument" do
    # TODO: make this less confusing, and test the argument better
    @test_date.beginning_of_fortnight(@test_date)               .should  == @test_date.beginning_of_week
    @test_date.beginning_of_fortnight(@test_date_plus_one_week) .should  == @test_date_minus_one_week.beginning_of_week
  end

end



