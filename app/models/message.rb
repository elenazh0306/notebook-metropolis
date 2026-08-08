class Message < ApplicationRecord
  belongs_to :citizen

  MAX_USER_MESSAGES = 10

  validate :user_message_limit, if: -> { role == "user" }

  private

  def user_message_limit
    if chat.messages.where(role: "user").where("created_at >= ?", 24.hours.ago).count >= MAX_USER_MESSAGES
      errors.add(:content, "Oh man, that was a lot of chatting for one day. Talk to you tomorrow!")
    end
  end
end
