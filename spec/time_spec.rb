
require 'rubygems'
require 'beginning_of_fortnight'

describe Time, "#beginning_of_fortnight" do
  before :each do
    @now_time = Time.now

    # Just an arbitrary date that I can test with
    @test_time                 = Time.parse('17-Dec-2010') # A Friday
    @test_time_start_week      = Time.parse('13-Dec-2010') # The Monday before
    @test_time_start_prev_week = Time.parse('06-Dec-2010') # The previous Monday before

    # Make sure it's reset back to use the default because some tests change this
    BeginningOfFortnight.reference_date = nil
  end

  it "can set and retrieve reference_week correctly" do
    BeginningOfFortnight.reference_date = @test_time
    BeginningOfFortnight.reference_week.should == @test_time.beginning_of_week
  end

  it "can also set reference_week using a string" do
    BeginningOfFortnight.reference_date = '01-Jun-1973'
    BeginningOfFortnight.reference_week.should == Time.parse('01-Jun-1973').beginning_of_week
  end

  it "returns a Time object" do
    [@now_time,@test_time].each do |t|
      t.beginning_of_fortnight.class.should == Time
      t.end_of_fortnight.class.should == Time
      t.next_fortnight.class.should == Time
    end
  end

  it "gives correct values for a test date with default reference" do
    # With default reference date
    # (With the default reference date, this date falls in the second week of a fornight)
    @test_time.beginning_of_fortnight .should == @test_time_start_prev_week
    @test_time.end_of_fortnight       .should == (@test_time_start_prev_week + 13.days).end_of_day
    @test_time.next_fortnight         .should == @test_time_start_prev_week + 14.days
  end

  it "flip_boundaries works as expected for the test date" do
    original = @test_time.beginning_of_fortnight
    BeginningOfFortnight.flip_boundaries
    flipped = @test_time.beginning_of_fortnight
    BeginningOfFortnight.flip_boundaries
    reflipped = @test_time.beginning_of_fortnight

    original.should_not == flipped
    original.should == reflipped
    (original.to_i - flipped.to_i).abs.should == 1.week
  end

  it "gives correct values for a test date with explict reference" do
    # Now explicitly set a reference date. Setting a reference date specifies that the given date
    # is in the first week of a fornight.
    BeginningOfFortnight.reference_date = @test_time
    @test_time.beginning_of_fortnight .should == @test_time_start_week

    # Now explicitly set another reference date. Should flip back to be same as the default.
    BeginningOfFortnight.reference_date = @test_time - 1.week
    @test_time.beginning_of_fortnight .should == @test_time_start_prev_week
  end

  it "gives sane values for Time.now" do
    bof = @now_time.beginning_of_fortnight
    @now_time.end_of_fortnight .should == (bof + 13.days).end_of_day
    @now_time.next_fortnight   .should == bof + 14.days

    # Test the reference week stuff again I guess
    BeginningOfFortnight.flip_boundaries
    alt_bof = @now_time.beginning_of_fortnight
    alt_bof.should_not == bof
    (bof.to_i - alt_bof.to_i).abs.should == 1.week
  end

  it "passes some edge case and misc sanity tests" do
    [@now_time,@test_time].each do |t|
      bof = t.beginning_of_fortnight
      eof = t.end_of_fortnight

      nxt = t.next_fortnight
      nxt2 = t.next_fortnight.next_fortnight
      prev = (t - 14.days).beginning_of_fortnight
      prev2 = (t - 28.days).beginning_of_fortnight

      # Basic sanity stuff
      # (Maybe overkill)
      (nxt - bof)  .should == 2.weeks
      (nxt2 - bof) .should == 4.weeks
      (nxt.end_of_fortnight - eof) .should == 2.weeks
      (nxt - prev) .should == 4.weeks

      # Actually not sure if beginning_of_week in AR is
      # always Monday, is it configurable? TODO: find out.
      bof.wday.should == 1 # Monday
      eof.wday.should == 0 # Sunday
      nxt.wday.should == 1 # Monday

      bof.hour.should == 0
      eof.hour.should == 23
      nxt.hour.should == 0

      bof.min.should == 0
      eof.min.should == 59
      nxt.min.should == 0

      bof.sec.should == 0
      eof.sec.should == 59
      nxt.sec.should == 0

      bof.should be <= t
      eof.should be >= t
      (t - bof).should be < 2.weeks
      (eof - t).should be < 2.weeks

      # Edge stuff
      (bof - 1.second).beginning_of_fortnight.should == bof - 14.days
      (eof + 1.second).end_of_fortnight.should == eof + 14.days

      (bof - 1.second          ).beginning_of_fortnight.should == prev
      (bof - 1.day             ).beginning_of_fortnight.should == prev
      (bof - 14.days           ).beginning_of_fortnight.should == prev
      (bof - 14.days - 1.second).beginning_of_fortnight.should == prev2

      (eof + 1.second          ).beginning_of_fortnight.should == nxt
      (eof + 1.day             ).beginning_of_fortnight.should == nxt
      (eof + 14.days           ).beginning_of_fortnight.should == nxt
      (eof + 14.days + 1.second).beginning_of_fortnight.should == nxt2

      # That should be enough I guess
    end
  end



end


