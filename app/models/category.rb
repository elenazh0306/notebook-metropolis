class Category < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy
  validates :name, uniqueness: { message: "You already have this category!"}
  validates :name, presence: { message: "You forgot the name!"}
  validates :sprite_image, presence: { message: "Pick a building!"}

  # sets the building sprite on the map grid
  def building_sprite
    sprite_image.presence || "default.png"
  end

  # sets the static image inside the room modal
  def room_graphic
    room_image.presence || "rooms/Cat_sleeping_in_cozy_room.jpeg"
  end

  # handles the room intro video fallback
  def intro_video
    room_video.presence || "rooms/Cat_sleeping_in_cozy_room.jpeg"
  end

  # handles the animation type fallback (default to continuous loops)
  def animation_schedule
    building_animation_type.presence || "continuous"
  end
end
