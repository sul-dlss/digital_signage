require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :report do
  require './lib/digital_signage.rb'

  DigitalSignage.call
end
