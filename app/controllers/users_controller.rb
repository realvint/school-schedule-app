class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.order(:created_at)
  end

  def show; end

  def edit; end

  def update
    @user.update(user_params)
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      respond_to do |format|
        render_turbo_stream_error
        format.turbo_stream do
          render turbo_stream: prepend_flash
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

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

  def user_params
    params.require(:user).permit(*User::ROLES)
  end

  def render_turbo_stream_error
    flash.now[:alert] = @user.errors.full_messages.join('; ')
  end
end
