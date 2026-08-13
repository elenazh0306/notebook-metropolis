class Category < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy

  def building_sprite
    sprite_image.presence || "default.png"
  end

  def room_graphic
    room_image.presence || "cat_room.png"
  end
end
