# Notion Ruby Client

A Ruby client for the Notion API.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Create a New Bot Integration](#create-a-new-bot-integration)
  - [Declare the API Token](#declare-the-api-token)
  - [API Client](#api-client)

## Installation

Add to Gemfile.

```
gem 'notion-ruby-client'
```

Run `bundle install`.

## Usage

### Create a New Bot Integration

To integrate your bot with Notion, you must first [create a new Notion Bot](https://www.notion.so/Getting-started-da32a6fc1bcc4403a6126ee735710d89).

1. Log into the workspace that you want your integration to be associated with.
2. Confirm that you are an Admin in the workspace (see Settings & Members > Members).
3. Go to Settings & Members, and click API

![A screenshot of the Notion page to create a bot](screenshots/create_notion_bot.png)

### Declare the API token

```ruby
Notion.configure do |config|
  config.token = ENV['NOTION_API_TOKEN']
end
```

For Rails projects, the snippet above would go to `config/application.rb`.

### API Client

#### Instanciating a new Notion API client

```ruby
client = Notion::Client.new
```

You can specify the token or logger on a per-client basis:

```ruby
client = Notion::Client.new(token: '<secret Notion API token>')
```

#### Users

Get a paginated list of [User objects](https://www.notion.so/User-object-4f8d1a2fc1e54680b5f810ed0c6903a6) for the workspace:

```ruby
client.users_list # retrieves the first page

client.users_list(start_cursor: 'fe2cc560-036c-44cd-90e8-294d5a74cebc')

client.users_list do |page|
  # paginate through all users
end
```

Get a single User:

```ruby
client.user(id: 'd40e767c-d7af-4b18-a86d-55c61f1e39a4')
```

#### Databases

Gets a paginated array of Page objects contained in the requested database, filtered and ordered according to the filter and sort references provided in the request.

```ruby
client.database_query(id: 'e383bcee-e0d8-4564-9c63-900d307abdb0')  # retrieves the first page

client.database_query(id: 'e383bcee-e0d8-4564-9c63-900d307abdb0', start_cursor: 'fe2cc560-036c-44cd-90e8-294d5a74cebc')

client.database_query((id: 'e383bcee-e0d8-4564-9c63-900d307abdb0') do |page|
  # paginate through all pages
end

# Filter and sort the database
sort = [
  {
    "property": "Last ordered",
    "direction": "ascending"
  }
]
filter = {
  "or": [
    {
      "property": "In stock",
      "checkbox": {
        "equals": true
      }
    },
    {
      "property": "Cost of next trip",
      "number": {
        "greater_than_or_equal_to": 2
      }
    }
  ]
}
client.database_query(id: 'e383bcee-e0d8-4564-9c63-900d307abdb0', sort: sort, filter: filter)
```

Get a single Database:

```ruby
client.database(id: 'e383bcee-e0d8-4564-9c63-900d307abdb0')
```

#### Pages

Create a page:

```ruby
properties = {
  "Name": [
    {
      "text": {
        "content": "Tuscan Kale"
      }
    }
  ],
  "Description": [
    {
      "text": {
        "content": "A dark green leafy vegetable"
      }
    }
  ],
  "Food group": {
    "name": "🥦 Vegetable"
  },
  "Price": 2.5
}
children = [
  {
    "object": "block",
    "type": "heading_2",
    "heading_2": {
      "text": [{ "type": "text", "text": { "content": "Lacinato kale" } }]
    }
  },
  {
    "object": "block",
    "type": "paragraph",
    "paragraph": {
      "text": [
        {
          "type": "text",
          "text": {
            "content": "Lacinato kale is a variety of kale with a long tradition in Italian cuisine, especially that of Tuscany. It is also known as Tuscan kale, Italian kale, dinosaur kale, kale, flat back kale, palm tree kale, or black Tuscan palm.",
            "link": { "url": "https://en.wikipedia.org/wiki/Lacinato_kale" }
          }
        }
      ]
    }
  }
]
client.create_page(
   parent: { database_id: 'e383bcee-e0d8-4564-9c63-900d307abdb0'},
   properties: properties,
   children: children
)
```

Retrieve a page:

```ruby
client.page(id: 'b55c9c91-384d-452b-81db-d1ef79372b75')
```

Update page properties:

```ruby
properties = {
  "In stock": true
}
client.update_page(id: 'b55c9c91-384d-452b-81db-d1ef79372b75', properties: properties)
```
