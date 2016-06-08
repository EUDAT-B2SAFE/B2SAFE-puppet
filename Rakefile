require 'rubygems'
require 'bundler/setup'
require 'rake/clean'

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet/version'
require 'puppet/vendor/semantic/lib/semantic' unless Puppet.version.to_f < 3.6
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'metadata-json-lint/rake_task'

# These gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end
begin
  require 'rubocop/rake_task'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

begin
  require 'puppet-strings/rake_tasks'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

exclude_paths = [
  "bundle/**/*",
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

clean_paths = [
  "Gemfile.lock",
  "vendor",
  "spec/fixtures",
]

CLEAN.include(clean_paths)

Rake::Task[:lint].clear

PuppetLint::RakeTask.new :lint do |config|
  config.disable_checks = ["80chars", "arrow_alignment", "class_inherits_from_params_class", "class_parameter_defaults", "only_variable_string"]
  config.fail_on_warnings = true
  config.ignore_paths = exclude_paths
  config.log_format = '%{path}:%{linenumber}:%{KIND}: %{message}'
end

PuppetSyntax.exclude_paths = exclude_paths

begin
  require 'parallel_tests/cli'
  desc 'Run spec tests in parallel'
  task :parallel_spec do
    Rake::Task[:spec_prep].invoke
    ParallelTests::CLI.new.run('-o "--format=progress" -t rspec spec/classes'.split)
    Rake::Task[:spec_clean].invoke
  end
  desc 'Run syntax, lint, spec and metadata tests in parallel'
  task :parallel_test => [
    :syntax,
    :lint,
    :parallel_spec,
    :metadata,
  ]
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :lint,
#  :spec,
  :metadata_lint,
]