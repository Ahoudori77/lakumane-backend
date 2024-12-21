class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :item
  
  scope :unread, -> { where(read: false) }

  after_commit :broadcast_unread_count, on: [:create, :update]

  private

  def broadcast_unread_count
    NotificationsChannel.broadcast_to(user, {
      unread_count: user.notifications.unread.count
    })
  end
end
