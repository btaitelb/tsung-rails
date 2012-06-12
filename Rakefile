require "bundler/gem_tasks"
require_relative "./lib/tsung-rails.rb"

load "lib/tsung/rails/tasks/tsung.rake"

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec
