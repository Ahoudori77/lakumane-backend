class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :item

  after_create_commit { broadcast_notification }

  private

  def broadcast_notification
    NotificationsChannel.broadcast_to(
      user,
      message: message,
      read: read,
      created_at: created_at
    )
  end
end
