# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Notion::Api::Endpoints::Search do
  let(:client) { Notion::Client.new }

  context 'search' do
    it 'searches', vcr: { cassette_name: 'search' } do
      response = client.search
      expect(response.results.size).to eq 2
    end

    it 'searches with a query', vcr: { cassette_name: 'search_with_query' } do
      response = client.search(query: 'Nicolas')
      expect(response.results.size).to eq 1
    end

    it 'paginated search', vcr: { cassette_name: 'paginated_search' } do
      results = []
      client.search(page_size: 2) do |page|
        results.concat page.results
      end
      expect(results.size).to eq 2
    end
  end
end
