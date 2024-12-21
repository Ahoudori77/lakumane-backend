module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/notifications
      def index
        all_unread_notifications = current_user.notifications.where(read: false)
        paginated_notifications = all_unread_notifications.page(params[:page]).per(10)
      
        render json: {
          notifications: paginated_notifications,
          total_pages: paginated_notifications.total_pages,
          unread_count: all_unread_notifications.size
        }
      end

      # PATCH /api/v1/notifications/:id
      def update
        notification = current_user.notifications.find(params[:id])
        notification.update!(read: true)
        render json: notification, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Notification not found" }, status: :not_found
      end
    end
  end
end
