# Clear existing data
Review.destroy_all
OrderItem.destroy_all
Order.destroy_all
LineItem.destroy_all
Cart.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

puts "Creating users..."

admin = User.create!(
  name: "Admin User",
  email: "admin@c164store.com",
  password: "password123",
  password_confirmation: "password123",
  admin: true
)

alice = User.create!(
  name: "Alice Johnson",
  email: "alice@example.com",
  password: "password123",
  password_confirmation: "password123"
)

bob = User.create!(
  name: "Bob Smith",
  email: "bob@example.com",
  password: "password123",
  password_confirmation: "password123"
)

[ admin, alice, bob ].each { |user| user.create_cart! }

puts "Creating categories..."

tshirts = Category.create!(name: "T-Shirts", description: "Everybody Loves Raymond graphic tees")
mugs = Category.create!(name: "Mugs & Drinkware", description: "Coffee mugs and drinkware for Raymond fans")

puts "Creating products..."

products_data = [
  {
    name: "Raymond Barone Vintage Tee",
    description: "Black vintage-style bootleg tee featuring Ray Romano as Raymond Barone. 90s collage graphic with Everybody Loves Raymond branding.",
    price: 24.99,
    stock: 30,
    category: tshirts,
    image_url: "/images/products/raymond-barone-tee.png"
  },
  {
    name: "Frank Barone Vintage Tee",
    description: "Black vintage-style bootleg tee honoring Frank Barone. Features Peter Boyle with classic Everybody Loves Raymond collage artwork.",
    price: 24.99,
    stock: 25,
    category: tshirts,
    image_url: "/images/products/frank-barone-tee.png"
  },
  {
    name: "Robert Barone Vintage Tee",
    description: "Black vintage-style bootleg tee starring Robert Barone. Includes police uniform and red sweater looks from the show.",
    price: 24.99,
    stock: 28,
    category: tshirts,
    image_url: "/images/products/robert-barone-tee.png"
  },
  {
    name: "Debra Barone Vintage Tee",
    description: "Black vintage-style bootleg tee featuring Debra Barone. Pink gradient lettering with classic show photo collage.",
    price: 24.99,
    stock: 22,
    category: tshirts,
    image_url: "/images/products/debra-barone-tee.png"
  },
  {
    name: "Cast Quote Tee — \"45 Years of Bondage\"",
    description: "White tee with cartoon illustration of the full Barone family and the iconic Marie quote: \"You still need reassurance after 45 years of bondage?\"",
    price: 22.99,
    stock: 35,
    category: tshirts,
    image_url: "/images/products/cast-quote-tee.png"
  },
  {
    name: "Everybody Loves Raymond Quote Mug",
    description: "Black ceramic mug covered in Everybody Loves Raymond quotes, cast photos, and show references. Perfect for your morning coffee.",
    price: 16.99,
    stock: 40,
    category: mugs,
    image_url: "/images/products/raymond-mug.png"
  }
]

products = products_data.map do |data|
  Product.create!(
    name: data[:name],
    description: data[:description],
    price: data[:price],
    stock: data[:stock],
    category: data[:category],
    image_url: data[:image_url]
  )
end

puts "Creating sample orders..."

order1 = Order.create!(user: alice, total: 0, status: "completed")
order1.order_items.create!(product: products[0], quantity: 1, unit_price: products[0].price)
order1.order_items.create!(product: products[5], quantity: 1, unit_price: products[5].price)
order1.update!(total: order1.order_items.sum { |i| i.unit_price * i.quantity })

order2 = Order.create!(user: bob, total: 0, status: "completed")
order2.order_items.create!(product: products[2], quantity: 1, unit_price: products[2].price)
order2.order_items.create!(product: products[4], quantity: 1, unit_price: products[4].price)
order2.update!(total: order2.order_items.sum { |i| i.unit_price * i.quantity })

puts "Adding items to Alice's cart..."
alice.cart.add_product(products[1], 1)
alice.cart.add_product(products[3], 1)

puts "Seed complete!"
puts "  Users: #{User.count}"
puts "  Categories: #{Category.count}"
puts "  Products: #{Product.count}"
puts "  Reviews: #{Review.count}"
puts "  Orders: #{Order.count}"
puts ""
puts "Login as admin: admin@c164store.com / password123"
puts "Login as customer: alice@example.com / password123"
