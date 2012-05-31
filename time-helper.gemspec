Gem::Specification.new do |s|
  s.name        = 'time-helper'
  s.version     = '1.3'
  s.date        = '2012-05-30'
  s.summary     = 'A few helper functions for the Time class, useful on ruby 1.8'
  s.description = <<EOF
  Adds a few methods to the Time class, more significant:\n
    strtotime which returns a Time object based on a string.\n
    also methods add and substract that allow you to do some easy date math (doesn't take leap months/years into account)\n also tomorrow and yesterday methods witch are like Time.now +- 1 day

**********************************************
*How is this diferent than just "Time.parse"?*
**********************************************

Time.parse does not work well with non-American formats, if like me, you're working with strings that have dates in a format like: DD/MM/YYYY Time.parse will not do. In fact, if you rewrite strtotime so it just calls parse a few of the tests included will fail.


New in 1.3:
Added support for time strings in the format you'd usualy pass to Time.parse
Added utc_parse method for the lazy, it parses the date and converts it to utc

New in 1.2
Tomorrow and Yesterday methods

New in 1.1 
I skiped this version.... because I suck at versioning 

EOF
  s.authors     = ["Arthur Silva"]
  s.email       = 'awls99@gmail.com'
  s.files       = %w[lib/time-helper.rb README]
  s.homepage    = 'https://github.com/awls99/time-helper'
end
