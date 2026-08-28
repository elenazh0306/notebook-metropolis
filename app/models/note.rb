class Note < ApplicationRecord
  belongs_to :category

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
end
