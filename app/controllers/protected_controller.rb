class ProtectedController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: { message: 'This is a protected endpoint', user: current_user }
  end
end
