beginning_of_fortnight
======================

Author: Simon Baird

Email: simon.baird@gmail.com

Source: https://github.com/simonbaird/beginning_of_fortnight

License: 'BSD-new' where the copyright holder is Simon Baird

Extends ActiveSupport to provide these methods for Time and Date objects:

* beginning_of_fortnight
* end_of_fortnight
* next_fortnight

These methods should work similarly to beginning_of_week, end_of_week and next_week.

Installation
============
    sudo gem install beginning_of_fortnight

Usage
=====

Basic Usage
-----------

    require 'rubygems'
    require 'beginning_of_fortnight'

    now = Time.now
    puts now.beginning_of_fortnight
    puts now.end_of_fortnight

Explicitly setting a reference date
-----------------------------------

    require 'rubygems'
    require 'beginning_of_fortnight'

    now = Time.now

    # Globally define fortnights such that this date is the first half of a fortnight
    ref_date = Time.parse('13-Oct-2010')
    BeginningOfFortnight.reference_date = ref_date

    puts now.beginning_of_fortnight # uses ref_date

    # Change your mind...
    BeginningOfFortnight.reference_date = Time.parse('20-Oct-2010')
    puts now.beginning_of_fortnight # should be different

    # You can also pass in a single use reference date if you want to mix it up
    other_ref_date = Time.parse('27-Oct-2010')
    puts now.beginning_of_fortnight(other_ref_date)

