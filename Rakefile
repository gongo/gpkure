#!/usr/bin/env rake

require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
  ENV['RACK_ENV'] = 'test'
  t.libs << '.'
  t.libs << 'test'
  t.test_files = FileList['test/test_*.rb']
end
