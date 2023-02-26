# Notion Ruby Client

[![Gem Version](https://badge.fury.io/rb/notion-ruby-client.svg)](http://badge.fury.io/rb/notion-ruby-client)
[![CI workflow badge](https://github.com/orbit-love/notion-ruby-client/actions/workflows/ci.yml/badge.svg)](https://github.com/orbit-love/notion-ruby-client/actions/workflows/ci.yml)

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
    - [Create a Database](#create-a-database)
    - [Update a Database](#update-a-database)
    - [Retrieve a database](#retrieve-a-database)
    - [List databases](#list-databases)
  - [Pages](#pages)
    - [Retrieve a page](#retrieve-a-page)
    - [Create a page](#create-a-page)
    - [Update page](#update-page)
    - [Retrieve a page property item](#retrieve-a-page-property-item)
  - [Blocks](#blocks)
    - [Retrieve a block](#retrieve-a-block)
    - [Update a block](#update-a-block)
    - [Delete a block](#delete-a-block)
    - [Retrieve block children](#retrieve-block-children)
    - [Append block children](#append-block-children)
  - [Comments](#comments)
    - [Retrieve comments](#retrieve-comments-from-a-page-or-block-by-id)
    - [Create a comment on a page](#create-a-comment-on-a-page)
    - [Create a comment on a discussion](#create-a-comment-on-a-discussion)
  - [Users](#users)
    - [Retrieve your token's bot user](#retrieve-your-tokens-bot-user)
    - [Retrieve a user](#retrieve-a-user)
    - [List all users](#list-all-users)
  - [Search](#search)
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

> :blue_book: Integrations don't have access to any pages (or databases) in the workspace at first. **A user must share specific pages with an integration in order for those pages to be accessed using the API.**

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

The client natively supports [cursor pagination](https://developers.notion.com/reference/pagination) for methods that allow it, such as `users_list`. Supply a block and the client will make repeated requests adjusting the value of `start_cursor` with every response. The default page size is set to 100 (Notion’s current default and maximum) and can be adjusted via `Notion::Client.config.default_page_size` or by passing it directly into the API call.

```ruby
all_users = []
client.users_list(page_size: 25) do |page|
  all_users.concat(page.results)
end
all_users # All users, retrieved 25 at a time
```

When using cursor pagination the client will automatically pause and then retry the request if it runs into [Notion rate limiting](https://developers.notion.com/reference/errors#request-limits). (It will pause for 10 seconds before retrying the request, a value that can be overriden with `Notion::Client.config.default_retry_after`.) If it receives too many rate-limited responses in a row it will give up and raise an error. The default number of retries is 100 and can be adjusted via `Notion::Client.config.default_max_retries` or by passing it directly into the method as `max_retries`.

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
client.database_query(database_id: 'e383bcee-e0d8-4564-9c63-900d307abdb0')  # retrieves the first page

client.database_query(database_id: 'e383bcee-e0d8-4564-9c63-900d307abdb0', start_cursor: 'fe2cc560-036c-44cd-90e8-294d5a74cebc')

client.database_query(database_id: 'e383bcee-e0d8-4564-9c63-900d307abdb0') do |page|
  # paginate through all pages
end

# Filter and sort the database
sorts = [
  {
    'timestamp': 'created_time',
    'direction': 'ascending'
  }
]
filter = {
  'or': [
    {
      'property': 'In stock',
      'checkbox': {
        'equals': true
      }
    },
    {
      'property': 'Cost of next trip',
      'number': {
        'greater_than_or_equal_to': 2
      }
    }
  ]
}
client.database_query(database_id: 'e383bcee-e0d8-4564-9c63-900d307abdb0', sorts: sorts, filter: filter)
```

See [Pagination](#pagination) for details about how to iterate through the list.

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/post-database-query).

#### Create a Database

Creates a database as a subpage in the specified parent page, with the specified properties schema.

```ruby
title = [
  {
    'type': 'text',
    'text': {
      'content': 'Grocery List',
      'link': nil
    }
  }
]
properties = {
  'Name': {
    'title': {}
  },
  'Description': {
    'rich_text': {}
  },
  'In stock': {
    'checkbox': {}
  },
  'Food group': {
    'select': {
      'options': [
        {
          'name': '🥦Vegetable',
          'color': 'green'
        },
        {
          'name': '🍎Fruit',
          'color': 'red'
        },
        {
          'name': '💪Protein',
          'color': 'yellow'
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

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/create-a-database).

#### Update a Database

Updates an existing database as specified by the parameters.

```ruby
title = [
  {
    'text': {
      'content': 'Orbit 💜 Notion'
    }
  }
]
client.update_database(database_id: 'dd428e9dd3fe4171870da7a1902c748b', title: title)
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/update-a-database).

#### Retrieve a database

Retrieves a [Database object](https://developers.notion.com/reference-link/database) using the ID specified.

```ruby
client.database(database_id: 'e383bcee-e0d8-4564-9c63-900d307abdb0')
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/retrieve-a-database).

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

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/list-databases).

### Pages

#### Retrieve a page

Retrieves a [Page object](https://developers.notion.com/reference-link/page) using the ID specified.

> :blue_book: Responses contains page **properties**, not page content. To fetch page content, use the [retrieve block children](#retrieve-block-children) endpoint.

```ruby
client.page(page_id: 'b55c9c91-384d-452b-81db-d1ef79372b75')
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/retrieve-a-page).

#### Create a page

Creates a new page in the specified database or as a child of an existing page.

If the parent is a database, the [property values](https://developers.notion.com/reference-link/page-property-values) of the new page in the properties parameter must conform to the parent [database](https://developers.notion.com/reference-link/database)'s property schema.

If the parent is a page, the only valid property is `title`.

The new page may include page content, described as [blocks](https://developers.notion.com/reference-link/block) in the children parameter.

The following example creates a new page within the specified database:

```ruby
properties = {
  'Name': {
    'title': [
      {
        'text': {
          'content': 'Tuscan Kale'
        }
      }
    ]
  },
  'Description': {
    'rich_text': [
      {
        'text': {
          'content': 'A dark green leafy vegetable'
        }
      }
    ]
  },
  'Food group': {
    'select': {
      'name': '🥦 Vegetable'
    }
  },
  'Price': {
    'number': 2.5
  }
}
children = [
  {
    'object': 'block',
    'type': 'heading_2',
    'heading_2': {
      'rich_text': [{
        'type': 'text',
        'text': { 'content': 'Lacinato kale' }
      }]
    }
  },
  {
    'object': 'block',
    'type': 'paragraph',
    'paragraph': {
      'rich_text': [
        {
          'type': 'text',
          'text': {
            'content': 'Lacinato kale is a variety of kale with a long tradition in Italian cuisine, especially that of Tuscany. It is also known as Tuscan kale, Italian kale, dinosaur kale, kale, flat back kale, palm tree kale, or black Tuscan palm.',
            'link': { 'url': 'https://en.wikipedia.org/wiki/Lacinato_kale' }
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

This example creates a new page as a child of an existing page.

```ruby
properties = {
  title: [
    {
      "type": "text",
      "text": {
        "content": "My favorite food",
        "link": null
      }
    }
  ]
}
children = [
  {
    'object': 'block',
    'type': 'heading_2',
    'heading_2': {
      'rich_text': [{
        'type': 'text',
        'text': { 'content': 'Lacinato kale' }
      }]
    }
  },
  {
    'object': 'block',
    'type': 'paragraph',
    'paragraph': {
      'rich_text': [
        {
          'type': 'text',
          'text': {
            'content': 'Lacinato kale is a variety of kale with a long tradition in Italian cuisine, especially that of Tuscany. It is also known as Tuscan kale, Italian kale, dinosaur kale, kale, flat back kale, palm tree kale, or black Tuscan palm.',
            'link': { 'url': 'https://en.wikipedia.org/wiki/Lacinato_kale' }
          }
        }
      ]
    }
  }
]
client.create_page(
   parent: { page_id: 'feb1cdfaab6a43cea4ecbc9e8de63ef7'},
   properties: properties,
   children: children
)
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/post-page).

#### Update page

Updates [page property values](https://developers.notion.com/reference-link/page-property-value) for the specified page. Properties that are not set via the `properties` parameter will remain unchanged.

If the parent is a database, the new [property values](https://developers.notion.com/reference-link/page-property-value) in the `properties` parameter must conform to the parent [database](https://developers.notion.com/reference-link/database)'s property schema.

```ruby
properties = {
  'In stock': {
    'checkbox': true
  }
}
client.update_page(page_id: 'b55c9c91-384d-452b-81db-d1ef79372b75', properties: properties)
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/patch-page).

#### Retrieve a page property item

Retrieves a `property_item` object for a given `page_id` and `property_id`. Depending on the property type, the object returned will either be a value or a [paginated](#pagination) list of property item values. See [Property item objects](https://developers.notion.com/reference/property-item-object) for specifics.

To obtain `property_id`'s, use the [Retrieve a database endpoint](#retrieve-a-database).

```ruby
client.page_property_item(
  page_id: 'b55c9c91-384d-452b-81db-d1ef79372b75',
  property_id: 'aBcD123'
)
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/retrieve-a-page-property).

### Blocks

#### Retrieve a block

Retrieves a [Block object](https://developers.notion.com/reference-link/block) using the ID specified.

> :blue_book: If a block contains the key `has_children: true`, use the [Retrieve block children](#retrieve-block-children) endpoint to get the list of children

```ruby
client.block(block_id: '9bc30ad4-9373-46a5-84ab-0a7845ee52e6')
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/retrieve-a-block).

#### Update a block

Updates the content for the specified block_id based on the block type. Supported fields based on the block object type (see [Block object](https://developers.notion.com/reference-link/block#block-type-object) for available fields and the expected input for each field).

**Note** The update replaces the entire value for a given field. If a field is omitted (ex: omitting checked when updating a to_do block), the value will not be changed.

```ruby
to_do = {
  'rich_text': [{
    'type': 'text',
    'text': { 'content': 'Lacinato kale' }
    }],
  'checked': false
}
client.update_block(block_id: '9bc30ad4-9373-46a5-84ab-0a7845ee52e6', 'to_do' => to_do)
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/retrieve-a-block).

#### Delete a block

Sets a [Block object](https://developers.notion.com/reference/block), including page blocks, to archived: true using the ID specified. Note: in the Notion UI application, this moves the block to the "Trash" where it can still be accessed and restored.

To restore the block with the API, use the [Update a block](#update-a-block) or [Update page](#update-page) respectively.

```ruby
client.delete_block(block_id: '9bc30ad4-9373-46a5-84ab-0a7845ee52e6')
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/delete-a-block).

#### Retrieve block children

Returns a paginated array of child [block objects](https://developers.notion.com/reference-link/block) contained in the block using the ID specified. In order to receive a complete representation of a block, you may need to recursively retrieve the block children of child blocks.

```ruby
client.block_children(block_id: 'b55c9c91-384d-452b-81db-d1ef79372b75')

client.block_children(block_id: 'b55c9c91-384d-452b-81db-d1ef79372b75', start_cursor: 'fe2cc560-036c-44cd-90e8-294d5a74cebc')

client.block_children(block_id: 'b55c9c91-384d-452b-81db-d1ef79372b75') do |page|
  # paginate through all children
end
```

See [Pagination](#pagination) for details about how to iterate through the list.

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/get-block-children).

#### Append block children

Creates and appends new children blocks to the parent block specified by `block_id`.

Returns a paginated list of newly created first level children block objects.

```ruby
children = [
  {
    "object": 'block',
    "type": 'heading_2',
    'heading_2': {
      'rich_text': [{
        'type': 'text',
        'text': { 'content': 'A Second-level Heading' }
      }]
    }
  }
]
client.block_append_children(block_id: 'b55c9c91-384d-452b-81db-d1ef79372b75', children: children)
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/patch-block-children).

### Comments

#### Retrieve comments from a page or block by id
```ruby
client.retrieve_comments(block_id: '1a2f70ab26154dc7a838536a3f430af4')
```
#### Create a comment on a page
```ruby
options = {
  parent: { page_id: '3e4bc91d36c74de595113b31c6fdb82c' },
  rich_text: [
    {
      text: {
        content: 'Hello world'
      }
    }
  ]
}
client.create_comment(options)
```
#### Create a comment on a discussion
```ruby
options = {
  discussion_id: 'ea116af4839c410bb4ac242a18dc4392',
  rich_text: [
    {
      text: {
        content: 'Hello world'
      }
    }
  ]
}
client.create_comment(options)
```

See the full endpoint documention on [Notion Developers](https://developers.notion.com/reference/comment-object).

### Users

#### Retrieve your token's bot user

Retrieves the bot [User](https://developers.notion.com/reference/user) associated with the API token provided in the authorization header. The bot will have an `owner` field with information about the person who authorized the integration.

```ruby
client.me
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/get-self).

#### Retrieve a user

Retrieves a [User](https://developers.notion.com/reference/user) using the ID specified.

```ruby
client.user(user_id: 'd40e767c-d7af-4b18-a86d-55c61f1e39a4')
```

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/get-user).

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

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/get-users).

### Search

Searches all pages and child pages that are shared with the integration. The results may include databases.

```ruby
client.search # search through every available page and database

client.search(query: 'Specific query') # limits which pages are returned by comparing the query to the page title

client.search(filter: { property: 'object', value: 'page' }) # only returns pages

client.search(sort: { direction: 'ascending', timestamp: 'last_edited_time' }) # sorts the results based on the provided criteria.

client.search(start_cursor: 'fe2cc560-036c-44cd-90e8-294d5a74cebc')

client.search do |page|
  # paginate through all search pages
end
```

See [Pagination](#pagination) for details about how to iterate through the list.

See the full endpoint documentation on [Notion Developers](https://developers.notion.com/reference/post-search).

## Acknowledgements

The code, specs and documentation of this gem are an adaptation of the fantastic [Slack Ruby Client](https://github.com/slack-ruby/slack-ruby-client) gem. Many thanks to its author and maintainer [@dblock](https://github.com/dblock) and [contributors](https://github.com/slack-ruby/slack-ruby-client/graphs/contributors).
