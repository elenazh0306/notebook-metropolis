class Category < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy
  has_many :citizens, dependent: :destroy
  validates :name, uniqueness: { message: "You already have this category!"}, unless: :system_category?
  validates :name, presence: { message: "You forgot the name!"}
  validates :sprite_image, presence: { message: "Pick a building!"}
  accepts_nested_attributes_for :notes
  # trigger hotspot method after creating category
  after_create_commit :hotspot, unless: :trash_category?

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

  def hotspot
    # Corkboard Hotspot
    self.notes.create!(
      title: "Corkboard introduction",
      content: "📌 This is your corkboard! Start with your first post-it note right now!",
      hotspot_type: "notice_board"
    )

    # Bookcase Hotspot
    self.notes.create!(
      title: "Library introduction",
      content: "📚 This is your bookshelf! Do you know the best part? You are the author of all of them!",
      hotspot_type: "bookcase"
    )

    # Laptop Hotspot
    self.notes.create!(
      title: "Terminal Workspace Logs",
      content: "💾 Time to enter the matrix! Start your journey right now!",
      hotspot_type: "laptop"
    )

    # Posters Hotspot
    self.notes.create!(
      title: "Inspirational Quote",
      content: "🌠 Turn your pictures into motivational posts! Just! Do! It!",
      hotspot_type: "posters"
    )
  end

  def trash_category?
    name == 'trash'
  end
end
