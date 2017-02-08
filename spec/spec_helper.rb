require 'jekyll'
require 'vcr'

unless ENV["NO_COVERALLS"]
  require 'coveralls'
  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "jekyll/gitlab/letsencrypt"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :faraday
  config.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.before { Jekyll::Gitlab::Letsencrypt::Configuration.reset! }
end
