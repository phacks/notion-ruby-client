# frozen_string_literal: true
require 'spec_helper'

describe Notion::Config do
  describe '#configure' do
    before do
      Notion.configure do |config|
        config.token = 'a token'
      end
    end

    it 'sets token' do
      expect(Notion.config.token).to eq 'a token'
    end
  end
end