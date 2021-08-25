# Notion Ruby Client

A Ruby client for the Notion API.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Create a New Bot Integration](#create-a-new-bot-integration)
  - [Declare the API token](#declare-the-api-token)
  - [API Client](#api-client)
    - [Instantiating a new Notion API client](#instantiating-a-new-notion-api-client)
    - [Pagination](#pagination)
- [Endpoints](#endpoints)
  - [Databases](#databases)
    - [Query a database](#query-a-database)
    - [Retrieve a database](#retrieve-a-database)
    - [List databases](#list-databases)
    - [Create a Database](#create-a-database)
  - [Pages](#pages)
    - [Create a page](#create-a-page)
    - [Retrieve a page](#retrieve-a-page)
    - [Update page](#update-page)
  - [Blocks](#blocks)
    - [Retrieve block children](#retrieve-block-children)
    - [Append block children](#append-block-children)
  - [Users](#users)
    - [List all users](#list-all-users)
    - [Retrieve a user](#retrieve-a-user)
- [Acknowledgements](#acknowledgements)

## Installation

Add to Gemfile.

```
gem 'notion-ruby-client'
```

Run `bundle install`.

## Usage

### Create a New Integration

> :blue_book: **Before you start**
>
> Make sure you are an **Admin** user in your Notion workspace. If you're not an Admin in your current workspace, [create a new personal workspace for free](https://www.notion.so/notion/Create-join-switch-workspaces-3b9be78982a940a7a27ce712ca6bdcf5#9332861c775543d0965f918924448a6d).

To create a new integration, follow the steps 1 & 2 outlined in the [Notion documentation](https://developers.notion.com/docs#getting-started). The “_Internal Integration Token_” is what is going to be used to authenticate API calls (referred to here as the “API token”).

### Declare the API token

```ruby
Notion.configure do |config|
  config.token = ENV['NOTION_API_TOKEN']
end
```

For Rails projects, the snippet above would go to `config/application.rb`.

### API Client

#### Instantiating a new Notion API client

```ruby
client = Notion::Client.new
```

You can specify the token or logger on a per-client basis:

```ruby
client = Notion::Client.new(token: '<secret Notion API token>')
```

#### Pagination

The client natively supports [cursor pagination](https://developers.notion.com/reference/pagination) for methods that allow it, such as `users_list`. Supply a block and the client will make repeated requests adjusting the value of `start_cursor` with every response.

```ruby
all_users = []
client.users_list do |page|
  all_users.concat(page.results)
end
all_users
```

When using cursor pagination the client will automatically pause and then retry the request if it runs into [Notion rate limiting](https://developers.notion.com/reference/errors#request-limits). (It will pause according to the `Retry-After` header in the 429 response before retrying the request.) If it receives too many rate-limited responses in a row it will give up and raise an error. The default number of retries is 100 and can be adjusted via `Notion::Client.config.default_max_retries` or by passing it directly into the method as `max_retries`.

You can also proactively avoid rate limiting by adding a pause between every paginated request with the `sleep_interval` parameter, which is given in seconds.

```ruby
all_users = []
client.users_list(sleep_interval: 5, max_retries: 20) do |page|
  # pauses for 5 seconds between each request
  # gives up after 20 consecutive rate-limited responses
  all_users.concat(page.results)
end
all_users
```

## Endpoints

### Databases

#### Query a database

Gets a paginated array of [Page](https://developers.notion.com/reference/page) objects contained in the database, filtered and ordered according to the filter conditions and sort criteria provided in the request.

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

See [Pagination](#pagination) for details about how to iterate through the list.

#### Retrieve a database

Retrieves a [Database object](https://developers.notion.com/reference-link/database) using the ID specified.

```ruby
client.database(id: 'e383bcee-e0d8-4564-9c63-900d307abdb0')
```

#### List databases

List all [Databases](https://developers.notion.com/reference-link/database) shared with the authenticated integration.

```ruby
client.databases_list # retrieves the first page

client.databases_list(start_cursor: 'fe2cc560-036c-44cd-90e8-294d5a74cebc')

client.databases_list do |page|
  # paginate through all databases
end
```

See [Pagination](#pagination) for details about how to iterate through the list.

#### Create a Database

Creates a database as a subpage in the specified parent page, with the specified properties schema.

```ruby
title = [
  {
    "type": "text",
    "text": {
      "content": "Grocery List",
      "link": nil
    }
  }
],
properties = {
  "Name": {
    "title": {}
  },
  "Description": {
    "rich_text": {}
  },
  "In stock": {
    "checkbox": {}
  },
  "Food group": {
    "select": {
      "options": [
        {
          "name": "🥦Vegetable",
          "color": "green"
        },
        {
          "name": "🍎Fruit",
          "color": "red"
        },
        {
          "name": "💪Protein",
          "color": "yellow"
        }
      ]
    }
  }
}
client.create_database(
  parent: { page_id: '98ad959b-2b6a-4774-80ee-00246fb0ea9b' },
  title: title,
  properties: properties
)
```

### Pages

#### Create a page

Creates a new page in the specified database or as a child of an existing page.

If the parent is a database, the [property values](https://developers.notion.com/reference-link/page-property-value) of the new page in the properties parameter must conform to the parent [database](https://developers.notion.com/reference-link/database)'s property schema.

If the parent is a page, the only valid property is `title`.

The new page may include page content, described as [blocks](https://developers.notion.com/reference-link/block) in the children parameter.

```ruby
properties = {
  "Name": {
    "title": [
      {
        "text": {
          "content": "Tuscan Kale"
        }
      }
    ]
  },
  "Description": {
    "rich_text": [
      {
        "text": {
          "content": "A dark green leafy vegetable"
        }
      }
    ]
  },
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

#### Retrieve a page

Retrieves a [Page object](https://developers.notion.com/reference-link/page) using the ID specified.

> :blue_book: Responses contains page **properties**, not page content. To fetch page content, use the [retrieve block children](#retrieve-block-children) endpoint.

```ruby
client.page(id: 'b55c9c91-384d-452b-81db-d1ef79372b75')
```

#### Update page

Updates [page property values](https://developers.notion.com/reference-link/page-property-value) for the specified page. Properties that are not set via the `properties` parameter will remain unchanged.

If the parent is a database, the new [property values](https://developers.notion.com/reference-link/page-property-value) in the `properties` parameter must conform to the parent [database](https://developers.notion.com/reference-link/database)'s property schema.

```ruby
properties = {
  "In stock": true
}
client.update_page(id: 'b55c9c91-384d-452b-81db-d1ef79372b75', properties: properties)
```

### Blocks

#### Retrieve block children

Returns a paginated array of child [block objects](https://developers.notion.com/reference-link/block) contained in the block using the ID specified. In order to receive a complete representation of a block, you may need to recursively retrieve the block children of child blocks.

```ruby
client.block_children(id: 'b55c9c91-384d-452b-81db-d1ef79372b75')

client.block_children(start_cursor: 'fe2cc560-036c-44cd-90e8-294d5a74cebc')

client.block_children_list do |page|
  # paginate through all children
end
```

See [Pagination](#pagination) for details about how to iterate through the list.

#### Append block children

Creates and appends new children blocks to the parent block `id` specified.

Returns a paginated list of newly created first level children block objects.

```ruby
children = [
  {
    "object": 'block',
    "type": 'heading_2',
    "heading_2": {
      "text": [{ "type": 'text', "text": { "content": 'A Second-level Heading' } }]
    }
  }
]
client.block_append_children(id: 'b55c9c91-384d-452b-81db-d1ef79372b75', children: children)
```

### Users

#### List all users

Returns a paginated list of [Users](https://developers.notion.com/reference/user) for the workspace.

```ruby
client.users_list # retrieves the first page

client.users_list(start_cursor: 'fe2cc560-036c-44cd-90e8-294d5a74cebc')

client.users_list do |page|
  # paginate through all users
end
```

See [Pagination](#pagination) for details about how to iterate through the list.

#### Retrieve a user

Retrieves a [User](https://developers.notion.com/reference/user) using the ID specified.

```ruby
client.user(id: 'd40e767c-d7af-4b18-a86d-55c61f1e39a4')
```

## Acknowledgements

The code, specs and documentation of this gem are an adaptation of the fantastic [Slack Ruby Client](https://github.com/slack-ruby/slack-ruby-client) gem. Many thanks to its author and maintainer [@dblock](https://github.com/dblock) and [contributors](https://github.com/slack-ruby/slack-ruby-client/graphs/contributors).
