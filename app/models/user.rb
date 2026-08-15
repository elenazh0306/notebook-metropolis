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
  "path": { buildable: false, name: "path" },
  "base": { buildable: true, name: "base" }
  }

  MAP_SIZES = {
    'small'  => { rows: 6,  columns: 6  },
    'medium' => { rows: 10, columns: 10 },
    'large'  => { rows: 15, columns: 15 }
  }

  BUILDINGS = ['default.png', 'red-roof.png', 'blue-house.png']

  private

  def set_default_map
    size = MAP_SIZES[map_size]
    rows = size[:rows]
    columns = size[:columns]
    self.tile_map = Array.new(rows) { Array.new(columns, 'grass') }

  end

end
