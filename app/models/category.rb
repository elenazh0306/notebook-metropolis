class Category < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy
  has_many :citizens, dependent: :destroy
  validates :name, uniqueness: { message: "You already have this category!"}, unless: :system_category?
  validates :name, presence: { message: "You forgot the name!"}
  validates :sprite_image, presence: { message: "Pick a building!"}
  accepts_nested_attributes_for :notes

  # sets the building sprite on the map grid
  def building_sprite
    sprite_image.presence || "default.png"
  end

  # sets the static image inside the room modal
  def room_graphic
    room_image.presence || "rooms/cozy_study.jpeg"
  end

  # handles the room intro video fallback
  def intro_video
    room_video.presence || "rooms/Cat_waking_up_on_couch.mp4"
  end

  # handles the animation type fallback (default to continuous loops)
  def animation_schedule
    building_animation_type.presence || "continuous"
  end

  private

  def system_category?
    name.downcase == "trash" # Skips uniqueness validation if the name is "trash"
  end
end
