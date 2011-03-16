Gem::Specification.new do |gemspec|
  gemspec.name        = 'beginning_of_fortnight'
  gemspec.version     = '1.0.1'
  gemspec.date        = '2011-03-16'
  gemspec.summary     = 'beginning_of_fortnight for ActiveSupport'
  gemspec.description = 'Extends ActiveSupport to provide beginning/end_of_fortnight methods similar to beginning/end_of_week.'
  gemspec.authors     = ['Simon Baird']
  gemspec.email       = 'simon.baird@gmail.com'
  gemspec.homepage    = 'http://github.com/simonbaird/beginning_of_fortnight'
  gemspec.files       = ["lib/beginning_of_fortnight.rb"]
  # This gem requires active_support obviously, but I don't really want to make it a formal dependency.
  # It seems like if you don't have active_support then you probably won't install this gem.
  #gemspec.add_dependency('activesupport')
end

