class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :map_size
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email address" }
  before_create :set_default_map
  has_many :categories, dependent: :destroy
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

TILE_TYPES = {
    "grass": { buildable: false, name: "grass" },
    "base":  { buildable: true,  name: "base" },

    # Decorative Trees
    "willow_tree": { buildable: false, name: "tree-willow" },

    # Grass Road Network
    "grass_road_v":          { buildable: false, name: "path grass-straight" },
    "grass_road_h":          { buildable: false, name: "path grass-straight rotate-90" },

    "grass_turn_ne":         { buildable: false, name: "path grass-turn" },
    "grass_turn_se":         { buildable: false, name: "path grass-turn rotate-90" },
    "grass_turn_sw":         { buildable: false, name: "path grass-turn rotate-180" },
    "grass_turn_nw":         { buildable: false, name: "path grass-turn rotate-270" },

    "grass_tcross_north":    { buildable: false, name: "path grass-tcross" },
    "grass_tcross_east":     { buildable: false, name: "path grass-tcross rotate-90" },
    "grass_tcross_south":    { buildable: false, name: "path grass-tcross rotate-180" },
    "grass_tcross_west":     { buildable: false, name: "path grass-tcross rotate-270" },

    "grass_fullcross":       { buildable: false, name: "path grass-fullcross" },

    # City Road Network
    "city_road_v":           { buildable: false, name: "path city-straight" },
    "city_road_h":           { buildable: false, name: "path city-straight rotate-90" },

    "city_turn_ne":          { buildable: false, name: "path city-turn" },
    "city_turn_se":          { buildable: false, name: "path city-turn rotate-90" },
    "city_turn_sw":          { buildable: false, name: "path city-turn rotate-180" },
    "city_turn_nw":          { buildable: false, name: "path city-turn rotate-270" },

    "city_tcross_north":     { buildable: false, name: "path city-tcross" },
    "city_tcross_east":      { buildable: false, name: "path city-tcross rotate-90" },
    "city_tcross_south":     { buildable: false, name: "path city-tcross rotate-180" },
    "city_tcross_west":      { buildable: false, name: "path city-tcross rotate-270" },

    "city_fullcross":        { buildable: false, name: "path city-fullcross" }
  }

  MAP_SIZES = {
    'small'  => { rows: 6,  columns: 6  },
    'medium' => { rows: 10, columns: 10 },
    'large'  => { rows: 15, columns: 15 },
    'xlarge'  => { rows: 20, columns: 20 }
  }

  BUILDINGS = [
    { name: "Red house",       url: 'red-roof.png',          css_class: 'house-tile--narrow' },
    { name: "Blue house",      url: 'blue-house.png',        css_class: 'house-tile--medium' },
    { name: "Brick Apartment", url: 'brick_apartment1.png',  css_class: 'house-tile--wide' },
    { name: "Hacker Tower",    url: 'hacker_tower.png',      css_class: 'house-tile--tall' },
    { name: "Gothic Library",    url: 'gothic_library.png',      css_class: 'house-tile--medium' }
  ]

  ROOMS = [
    { name: "cozy_study",
      display: "Cozy study room",
      url: 'rooms/cozy_study.jpeg'},
    { name: "gothic_library",
      display: "Gothic library",
      url: 'rooms/gothic_library.jpeg'},
    { name: "hackercat_room",
      display: "Futuristic lab",
      url: 'rooms/hackercat_room.jpeg'},
    ]

  ROOM_VIDEOS = {
    "cozy_study" => "rooms/Cat_waking_up_on_couch.mp4",
    "gothic_library" => "rooms/Gargoyle_cat_licking_paw.mp4",
    "hackercat_room" => "rooms/Cat_paws_at_laptop_keyboard.mp4"
  }.freeze

  private

  def set_default_map
    size = MAP_SIZES[map_size]
    rows = size[:rows]
    columns = size[:columns]
    self.tile_map = Array.new(rows) { Array.new(columns, 'grass') }
  end

end
