class Note < ApplicationRecord
  belongs_to :category
  has_one_attached :image
  validate :image_for_poster

  include PgSearch::Model

  pg_search_scope :search_by_title_and_content,
                  against: {
                    title: "A",
                    content: "B"
                  },
                  using: {
                    tsearch: {
                      prefix: false,
                      dictionary: "simple"
                    }
                  }

  # We ensures default subfolder is "notice_board"
  after_initialize :set_default_hotspot_type, if: :new_record?

  private

  def set_default_hotspot_type
    self.hotspot_type ||= "notice_board" # Conditional Assignment - to assign to "notice_board" if nil
  end

  def image_for_poster
    return unless image.attached?
    return if hotspot_type == "posters"

    errors.add(:image, "Images can only be uplodated to the Poster hotspot")
  end
end
