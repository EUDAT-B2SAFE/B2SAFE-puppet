source ENV["GEM_SOURCE"] || "https://rubygems.org"

group :test do
  gem "rake"
  if puppet_gem_version = ENV["PUPPET_GEM_VERSION"]
    gem "puppet", ENV["PUPPET_GEM_VERSION"]
  else
    gem "puppet"
  end
  gem "puppet-lint"
  gem "puppet-lint-param-docs"
  gem "puppet-lint-absolute_classname-check"
  gem "puppet-lint-absolute_template_path"
  gem "puppet-lint-trailing_newline-check"
  gem "puppet-lint-unquoted_string-check"
  gem "puppet-lint-leading_zero-check"
  gem "puppet-lint-variable_contains_upcase"
  gem "puppet-lint-numericvariable"
  gem "rspec-puppet"
  gem "rspec-puppet-facts"
  gem "puppet-syntax"
  gem "puppetlabs_spec_helper"
  gem "metadata-json-lint"
  gem "rspec", "< 3.2.0" # Support for 1.8.7
  gem "rspec-retry"
  gem "serverspec"
  gem "simplecov", ">= 0.11.0"
  gem "simplecov-console"
  gem "versionomy",                   :require => false
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "beaker", "~> 2.0"
  gem "beaker-puppet_install_helper", :require => false
  gem "beaker-rspec"
  gem "puppet-blacksmith"
  gem "guard-rake"
  gem "pry"
  gem "yard"
  gem "parallel_tests" # requires at least Ruby 1.9.3
  gem "rubocop", :require => false # requires at least Ruby 1.9.2
end
