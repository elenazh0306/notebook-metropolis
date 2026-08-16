class Note < ApplicationRecord
  belongs_to :category

  # We ensures default subfolder is "notice_board"
  after_initialize :set_default_subfolder, if: :new_record?

  private

  def set_default_subfolder
    self.subfolder ||= "notice_board" # Conditional Assignment - to assign to "notice_board" if nil
  end
end
