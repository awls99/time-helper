Gem::Specification.new do |s|
  s.name        = 'time-helper'
  s.version     = '1.3'
  s.date        = '2012-05-30'
  s.summary     = 'A few helper functions for the Time class, useful on ruby 1.8'
  s.description = "Adds a few methods to the Time class, more significant:\n
    strtotime which returns a Time object based on a string.\n
    also methods add and substract that allow you to do some easy date math (doesn't take leap months/years into account)\n also tomorrow and yesterday methods witch are like Time.now +- 1 day "
  s.authors     = ["Arthur Silva"]
  s.email       = 'awls99@gmail.com'
  s.files       = %w[lib/time-helper.rb README]
  s.homepage    =
    'https://github.com/awls99/time-helper'
end
