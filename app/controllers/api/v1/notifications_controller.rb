module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate_user!

      def index
        @notifications = current_user.notifications.order(created_at: :desc)
        render json: @notifications
      end

      def unread
        @notifications = current_user.notifications.unread
        render json: @notifications
      end

      def update
        notification = current_user.notifications.find(params[:id])
        notification.update(read: true)
        render json: notification
      end
    end
  end
end
