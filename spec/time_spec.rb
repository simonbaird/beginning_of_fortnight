
require 'rubygems'
require 'beginning_of_fortnight'

describe Time, "#beginning_of_fortnight" do
  it "Returns a Time object" do
    Time.now.beginning_of_fortnight.class.should == Time
    Time.now.end_of_fortnight.class.should == Time
  end

  before :each do
    @test_time = Time.parse('19-Dec-2010')
    @now_time = Time.now
  end

  it "Gives correct values for a certain date with default reference" do
    # With default reference date
    # (With the default reference date, this date falls in the second week of a fornight)
    @test_time.beginning_of_fortnight .should == Time.parse('06-Dec-2010')
    @test_time.next_fortnight         .should == Time.parse('20-Dec-2010')
    @test_time.end_of_fortnight       .should == Time.parse('19-Dec-2010').end_of_day
  end

  it "Gives correct values for a certain date with explict reference" do

    # Now explicitly set a reference date. Setting a reference date specifies that the given date
    # is in the first week of a fornight.
    BeginningOfFortnight.reference_date = @test_time
    @test_time.beginning_of_fortnight .should == Time.parse('13-Dec-2010')
    @test_time.next_fortnight         .should == Time.parse('27-Dec-2010')
    @test_time.end_of_fortnight       .should == Time.parse('26-Dec-2010').end_of_day

    # Now explicitly set another reference date. Should flip back to be same as the default.
    BeginningOfFortnight.reference_date = @test_time - 1.week
    @test_time.beginning_of_fortnight .should == Time.parse('06-Dec-2010')
    @test_time.next_fortnight         .should == Time.parse('20-Dec-2010')
    @test_time.end_of_fortnight       .should == Time.parse('19-Dec-2010').end_of_day

    # Now explicitly set another reference date. Should flip back to be same as the default.
    BeginningOfFortnight.reference_date = @test_time.next_week
    @test_time.beginning_of_fortnight .should == Time.parse('06-Dec-2010')
    @test_time.next_fortnight         .should == Time.parse('20-Dec-2010')
    @test_time.end_of_fortnight       .should == Time.parse('19-Dec-2010').end_of_day
  end


end


