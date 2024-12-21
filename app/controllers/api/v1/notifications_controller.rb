module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/notifications
      def index
        notifications = current_user.notifications.where(read: false)
        render json: notifications, status: :ok
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
