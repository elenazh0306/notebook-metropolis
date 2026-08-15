class Category < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :sprite_image, presence: true

  def building_sprite
    sprite_image.presence || "default.png"
  end

  def room_graphic
    room_image.presence || "cat_room.png"
  end
end
