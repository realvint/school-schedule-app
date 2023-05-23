class UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]

  def index
    @users = User.order(:created_at)
  end

  def show; end

  def destroy
    if @user != current_user
      @user.destroy
      redirect_to users_path, notice: 'User was destroyed'
    else
      respond_to do |format|
        flash.now[:alert] = 'Action Forbidden!'
        format.turbo_stream do
          render turbo_stream: prepend_flash
        end
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
