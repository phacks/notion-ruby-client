# frozen_string_literal: true
require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/notion'
  config.hook_into :webmock
  # config.default_cassette_options = { record: :new_episodes }
  config.configure_rspec_metadata!
  config.before_record do |i|
    i.request.body.gsub!(ENV['NOTION_API_TOKEN'], 'token') if ENV.key?('NOTION_API_TOKEN')
    i.response.body.force_encoding('UTF-8')
  end
end
