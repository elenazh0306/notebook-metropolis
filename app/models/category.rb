class Category < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy
  validates :name, uniqueness: { message: "You already have this category!"}
  validates :name, presence: { message: "You forgot the name!"}
  validates :sprite_image, presence: { message: "Pick a building!"}

  def building_sprite
    sprite_image.presence || "default.png"
  end

  def room_graphic
    room_image.presence || "cat_room.png"
  end
end
