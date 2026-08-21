# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "deleting old seeds"
User.destroy_all

puts "creating a new user"
user = User.create!(name: "user", email: "email@email.com", password: "111111", map_size: "small")
user.tile_map = [
  ["grass", "grass", "grass", "grass", "grass", "grass"],
  ["grass", "base", "grass", "grass", "grass", "grass"],
  ["grass", "grass", "grass", "grass", "grass", "grass"],
  ["grass", "grass", "grass", "grass", "grass", "grass"],
  ["grass", "grass", "grass", "grass", "grass", "grass"],
  ["grass", "grass", "grass", "grass", "grass", "grass"]
]
user.save!

category = user.categories.create!(
  name: "Cozy Study",
  sprite_image: "red-roof.png",
  room_image: "cat_room.png",
  x: 1,
  y: 1
)

# 1. Notice Board / Corkboard Hotspot
category.notes.create!(
  title: "Community Board Announcement",
  content: "Don't forget the team demo presentation at 5 PM!",
  hotspot_type: "notice_board"
)

# 2. Bookcase Hotspot
category.notes.create!(
  title: "Recommended Reading List",
  content: "1. Neuromancer\n2. Snow Crash\n3. Winnie the Pooh",
  hotspot_type: "bookcase"
)

# 3. Laptop Hotspot
category.notes.create!(
  title: "Terminal Workspace Logs",
  content: "Worked on room modals and stuff. Also drank coffee...",
  hotspot_type: "laptop"
)

# 4. Posters Hotspot
category.notes.create!(
  title: "Inspirational Quote",
  content: "'Coding is really hard to be hardly average at' -Anonymous Bootcamp Student",
  hotspot_type: "posters"
)

puts "New user, category, and 4 hotspot notes seeded successfully!"
