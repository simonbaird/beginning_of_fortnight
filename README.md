beginning_of_fortnight
======================

Author: Simon Baird
Email: simon.baird@gmail.com

Purpose
-------

Extends ActiveSupport to provides beginning_of_fortnight and end_of_fortnight methods similar to
beginning_of_week and end_of_week.

Installation
------------

    sudo gem install beginning_of_fortnight

Example Usage
-------------

    require 'rubygems'
    require 'active_support'
    require 'beginning_of_fortnight'
    now = Time.now
    puts now.beginning_of_fortnight
    puts now.end_of_fortnight


TODO
----

* tests
* gem requirements
* bundler??
