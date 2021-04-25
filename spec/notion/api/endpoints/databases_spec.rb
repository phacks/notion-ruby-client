# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Databases do
  let(:client) { Notion::Client.new }
  let(:database_id) { '89b30a70-ce51-4646-ab4f-5fdcb1d5e76c' }

  context 'databases' do
    it 'retrieves', vcr: { cassette_name: 'database' } do
      response = client.database(id: database_id)
      expect(response.title.first.plain_text).to eql 'A Notion database'
    end

    it 'queries', vcr: { cassette_name: 'database_query' } do
      response = client.database_query(id: database_id)
      expect(response.results.length).to be >= 1
    end

    it 'paginated queries', vcr: { cassette_name: 'paginated_database_query' } do
      pages = []
      client.database_query(id: database_id, limit: 1) do |page|
        pages.concat page.results
      end
      expect(pages.size).to be >= 1
    end
  end
end