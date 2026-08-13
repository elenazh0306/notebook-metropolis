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
user = User.create!(name: "user", email: "email@email.com", password: "111111")
user.tile_map = [["grass", "grass"], ["path", "base"]]
user.save!

category = user.categories.create!(
  name: "Cozy Study",
  sprite_image: "default.png",
  room_image: "cat_room.png",
  x: 1,
  y: 1
)

category.notes.create!(
  title: "First Study Note",
  content: "Rooms and Modals and Notes and Turbo Frames documentation!"
)

puts "New user, category, and note seeded successfully!"