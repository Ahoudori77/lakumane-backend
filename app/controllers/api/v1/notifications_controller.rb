module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate_user!

      def index
        notifications = current_user.notifications.order(created_at: :desc)
        render json: notifications
      end

      def unread
        unread_notifications = current_user.notifications.unread
        render json: unread_notifications
      end

      def update
        notification = current_user.notifications.find(params[:id])
        if notification.update(read: true)
          render json: notification
        else
          render json: { errors: notification.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
