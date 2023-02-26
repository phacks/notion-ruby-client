# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Comments do
  let(:client) { Notion::Client.new }
  let(:discussion_comment) do
    {
      discussion_id: 'ea116af4839c410bb4ac242a18dc4392',
      rich_text: [
        {
          text: {
            content: 'test comment'
          }
        }
      ]
    }
  end
  let(:page_comment) do
    {
      parent: { page_id: '3e4bc91d36c74de595113b31c6fdb82c' },
      rich_text: [
        {
          text: {
            content: 'test comment'
          }
        }
      ]
    }
  end

  describe '#retrieve_comments' do
    it 'retrieves comments', vcr: { cassette_name: 'retrieve_comments' } do
      response = client.retrieve_comments(block_id: '1a2f70ab26154dc7a838536a3f430af4')
      expect(response.results.size).to eq 1
    end
  end

  describe '#create_comment' do
    it 'creates a comment on a page', vcr: { cassette_name: 'create_page_comment' } do
      response = client.create_comment(page_comment)
      expect(response.created_time).not_to be_empty
    end

    it 'creates a comment on a discussion', vcr: { cassette_name: 'create_discussion_comment' } do
      response = client.create_comment(discussion_comment)
      expect(response.created_time).not_to be_empty
    end
  end
end
