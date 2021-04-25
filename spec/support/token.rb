# frozen_string_literal: true
RSpec.configure do |config|
  config.before do
    @old_token = Notion::Config.token
  end
  config.after do
    Notion::Config.reset
    Notion::Config.token = @old_token
  end
end