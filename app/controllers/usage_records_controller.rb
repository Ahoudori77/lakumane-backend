class UsageRecordsController < ApplicationController
  def create
    usage_record = UsageRecord.new(usage_record_params)
    if usage_record.save
      render json: usage_record, status: :created
    else
      render json: { errors: usage_record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def usage_record_params
    params.require(:usage_record).permit(:item_id, :user_id, :usage_date, :quantity, :reason)
  end
end