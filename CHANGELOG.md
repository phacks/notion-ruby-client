### 0.1.0-beta1 (2021-08-29)

#### New

- Add support for the following new endpoints:
  - [Update database](https://developers.notion.com/reference/update-a-database)
  - [Update page](https://developers.notion.com/reference/patch-page)
  - [Retrieve a block](https://developers.notion.com/reference/retrieve-a-block)
  - [Update a block](https://developers.notion.com/reference/update-a-block)
  - [Search](https://developers.notion.com/reference/search)
- Update Notion API Version to `2021-08-16`
- Add `bin/console` command for better DX
- Overhauled documentation

#### Upgrade instructions

- Please refer to the Notion Changelog to see breaking changes for version `2021-08-16`
- Regarding this gem, a lot of `id` parameters got renamed to `block_id`, `page_id`, `user_id` and `database_id`. You might need to rename those in your code as well.

### 0.0.8 (2021-07-27)

- Bump `Notion-Version` header to `2021-05-13` (@H0R15H0)
- Add support for the new Create database endpoint (@H0R15H0)

### 0.0.7 (2021-06-17)

- Fixes the query parameter for fetching a page resource

### 0.0.6 (2021-06-09)

- Added `Notion-Version` required header to all requests

### 0.0.5 (2020-04-25)

- Added support for Blocks endpoints

### 0.0.4 (2020-04-25)

- Added specs and a CI process with GitHub Actions
- Added support for GET /databases, POST /databases/<:id>/query endpoints
- Added support for `content` when creating a page

### 0.0.3 (2020-01-30)

- The gem now covers all available endpoints to date
- Better error handling and logging

### 0.0.2 (2020-01-29)

- Fixed blocking bug present in 0.0.1

### 0.0.1 (2020-01-29)

- Initial alpha public release. Suffers from a bug that prevents installation.
