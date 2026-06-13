# Everybody Loves Merch

Online store built with Rails for CSEN 164. Users can browse products, add items to a cart, place orders, and write reviews. Admins can manage products and categories.

## Features

- Product catalog with search and category filter
- User sign up, login, logout
- Shopping cart and checkout
- Order history (users see their own orders; admin sees all)
- Product reviews with ratings
- Category management (admin)

## Models

```
User has_one :cart, has_many :orders, has_many :reviews
Category has_many :products
Product belongs_to :category
Cart belongs_to :user, has_many :line_items
Order belongs_to :user, has_many :order_items
Review belongs_to :user, belongs_to :product
```

## Setup

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

Open http://localhost:3000

## Login

| Role  | Email               | Password    |
|-------|---------------------|-------------|
| Admin | admin@c164store.com | password123 |
| User  | alice@example.com   | password123 |
| User  | bob@example.com     | password123 |

## Live site

http://18.225.222.28

## Deploy

Uses Kamal + Docker. Set `EC2_IP`, `SSH_KEY`, `DOCKER_USERNAME`, and `KAMAL_REGISTRY_PASSWORD`, then run `bin/deploy-to-aws`.
