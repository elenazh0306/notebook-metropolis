class Category < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy
  validates :name, uniqueness: { message: "You already have this category!"}, unless: :system_category?
  validates :name, presence: { message: "You forgot the name!"}
  validates :sprite_image, presence: { message: "Pick a building!"}

  def building_sprite
    sprite_image.presence || "default.png"
  end

  def room_graphic
    room_image.presence || "cat_room.png"
  end

  private

  def system_category?
    name.downcase == "trash" # Skips uniqueness validation if the name is "trash"
  end
end
