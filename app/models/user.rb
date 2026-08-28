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
    "oak_tree":    { buildable: false, name: "tree-oak" },
    "poplar_tree": { buildable: false, name: "tree-poplar" },
    "sakura_tree": { buildable: false, name: "tree-sakura" },
    "tree_grove": { buildable: false, name: "tree-grove" },
    "wild_grove": { buildable: false, name: "wild-grove" },
    "pine_grove": { buildable: false, name: "pine-grove" },
    "park_trees": { buildable: false, name: "park-trees" },

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
    { name: "Red house",         url: 'red-roof.png',          css_class: 'house-tile--narrow' },
    { name: "Blue house",        url: 'blue-house.png',        css_class: 'house-tile--medium1' },
    { name: "Brick Apartment 1", url: 'brick_apartment1.png',  css_class: 'house-tile--wide' },
    { name: "Brick Apartment 2", url: 'brick_apartment2.png',  css_class: 'house-tile--xwide1' },
    { name: "Brick Apartment 3", url: 'brick_apartment3.png',  css_class: 'house-tile--xwide2' },
    { name: "Brick Apartment 4", url: 'brick_apartment4.png',  css_class: 'house-tile--medium1' },
    { name: "Convini 1",         url: 'convini1.png',          css_class: 'house-tile--xwide3' },
    { name: "Convini 2",         url: 'convini2.png',          css_class: 'house-tile--xwide3' },
    { name: "Clock Tower",       url: 'clock_tower.png',       css_class: 'house-tile--xwide3' },
    { name: "Ramen Train",       url: 'ramen_train.png',       css_class: 'house-tile--xwide3' },
    { name: "Coffee Shop 1",     url: 'coffee_shop1.png',      css_class: 'house-tile--xwide3' },
    { name: "Coffee Shop 2",     url: 'coffee_shop2.png',      css_class: 'house-tile--xwide3' },
    { name: "Clock Tower",       url: 'clock_tower.png',       css_class: 'house-tile--xwide3' },
    { name: "Finance Tower 1",   url: 'finance1.png',          css_class: 'house-tile--tall1' },
    { name: "Finance Tower 2",   url: 'finance2.png',          css_class: 'house-tile--tall2' },
    { name: "Finance Tower 3",   url: 'finance3.png',          css_class: 'house-tile--tall3' },
    { name: "Finance Tower 4",   url: 'finance4.png',          css_class: 'house-tile--medium3' },
    { name: "Hacker Tower 1",    url: 'hacker_tower.png',      css_class: 'house-tile--tall1' },
    { name: "Server House 1",    url: 'server_house1.png',     css_class: 'house-tile--medium1' },
    { name: "Server House 2",    url: 'server_house2.png',     css_class: 'house-tile--medium1' },
    { name: "Hacker Tower 2",    url: 'hacker_tower2.png',     css_class: 'house-tile--tall1' },
    { name: "Hacker Tower 3",    url: 'hacker_tower3.png',     css_class: 'house-tile--tall1' },
    { name: "Gothic Library 1",  url: 'gothic_library.png',    css_class: 'house-tile--narrow' },
    { name: "Gothic Library 2",  url: 'gothic_library2.png',   css_class: 'house-tile--narrow' },
    { name: "Tea Pavilion",      url: 'tea_pavilion.png',      css_class: 'house-tile--large' },
    { name: "Cozy Hut 1",        url: 'cozy_hut.png',          css_class: 'house-tile--xwide3' },
    { name: "Cozy Hut 2",        url: 'cozy_hut2.png',         css_class: 'house-tile--xwide3' },
    { name: "Greenhouse",        url: 'greenhouse1.png',       css_class: 'house-tile--medium2' },
    { name: "Apothecary",        url: 'apothecary.png',        css_class: 'house-tile--tall2' },
    { name: "Observatory",       url: 'observatory.png',       css_class: 'house-tile--medium2' }
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
