# frozen_string_literal: true
RSpec.configure do |config|
  config.before do
    @old_token = Notion::Config.token
  end
  config.after do
    Notion::Config.token = @old_token
    Notion::Config.reset
  end
end