
require 'rubygems'
require 'beginning_of_fortnight'

describe BeginningOfFortnight do

  it "can set and retrieve reference_date correctly using a Time object" do
    now_time = Time.now
    BeginningOfFortnight.reference_date = now_time

    BeginningOfFortnight.reference_date.class.should == Time
    BeginningOfFortnight.reference_date.should == now_time
  end

  it "can set set and retrieve reference_date correctly using a Date object" do
    BeginningOfFortnight.reference_date = today_date = Date.today

    BeginningOfFortnight.reference_date.should == today_date.to_time
    BeginningOfFortnight.reference_date.class.should == Time
  end

end




