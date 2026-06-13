# C164 Store — Online Store Extension

A Ruby on Rails online store application built for CSEN 164 Assignment #2. Users can browse products by category, add items to a cart, checkout, view order history, and write product reviews. Admin users can manage products and categories.

## Main Features

- **Product catalog** with search by name and filter by category
- **Add to Cart** from the product detail page (requires login)
- **User accounts** — sign up, log in, log out with session persistence
- **Shopping cart** — update quantities and checkout
- **Order history** — users see only their own orders; admins see all orders
- **Product reviews** — rating (1–5) and comment; users edit/delete only their own reviews; average rating displayed on product pages
- **Product categories** — admin CRUD; products belong to a category
- **Authorization** — admin-only product/category management; users cannot view others' orders or reviews

## Models and Associations

```
User
  has_one :cart
  has_many :orders
  has_many :reviews

Category
  has_many :products

Product
  belongs_to :category
  has_many :line_items, :order_items, :reviews

Cart
  belongs_to :user
  has_many :line_items

LineItem
  belongs_to :cart
  belongs_to :product

Order
  belongs_to :user
  has_many :order_items

OrderItem
  belongs_to :order
  belongs_to :product

Review
  belongs_to :user
  belongs_to :product
```

## Requirements

- Ruby 3.x
- Rails 8.1
- SQLite3

## How to Run

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

Visit http://localhost:3000

## Sample Login Credentials

After running `rails db:seed`:

| Role     | Email              | Password   |
|----------|--------------------|------------|
| Admin    | admin@c164store.com | password123 |
| Customer | alice@example.com  | password123 |
| Customer | bob@example.com    | password123 |

## Known Limitations

- No payment processing (orders are placed immediately on checkout)
- Product images use external URLs only (no file upload)
- No email notifications for orders
- AWS deployment is not included in this repository — deploy separately using Kamal or your preferred method

## Assignment Requirements Checklist

- [x] Add to Cart on product detail page
- [x] User sign up / login / logout / sessions
- [x] Orders belong to users; order history with authorization
- [x] Product Reviews (additional feature)
- [x] Product Categories and Filtering (additional feature)
- [x] CRUD for Products and Categories (admin) and Reviews (users)
- [x] Validations on all models
- [x] Search/filter products by name and category
- [x] Navigation bar, home page, index/show pages, forms
- [x] Seed data (`rails db:seed`)
