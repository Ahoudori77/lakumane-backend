module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate_user!
      skip_before_action :authenticate_user!, only: [:show]
      def index
        notifications = current_user.notifications
        notifications = notifications.by_category(params[:category]) if params[:category].present?
        render json: notifications.order(created_at: :desc)
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

      def create
        notification = Notification.new(notification_params)
        if notification.save
          render json: notification, status: :created
        else
          render json: notification.errors, status: :unprocessable_entity
        end
      end

      def show
        notification = Notification.find_by(id: params[:id], user_id: current_user&.id)
        if notification
          render json: notification
        else
          render json: { error: 'Notification not found or access denied' }, status: :not_found
        end
      end
      
    
      private
    
      def notification_params
        params.require(:notification).permit(:message, :category, :user_id, :item_id, :read)
      end
    end
  end
end
