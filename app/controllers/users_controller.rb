class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy resend_invitation require_admin_or_inviter require_admin_or_owner]
  before_action :require_admin, only: %i[destroy]
  before_action :require_admin_or_inviter, only: %i[resend_invitation]
  before_action :require_admin_or_owner, only: %i[show edit update]

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

  def resend_invitation
    @user.invite!
    redirect_to @user, notice: 'Invitation were resent'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    list_allowed_params = []
    list_allowed_params += [:name] if current_user == @user || current_user.admin?
    list_allowed_params += [*User::ROLES] if current_user.admin?

    params.require(:user).permit(list_allowed_params)
  end

  def render_turbo_stream_error
    flash.now[:alert] = @user.errors.full_messages.join('; ')
  end

  def require_admin
    return if current_user.admin?

    redirect_to root_path, alert: 'Action Forbidden!'
  end

  def require_admin_or_inviter
    return if current_user.admin? || @user.invited_by == current_user

    redirect_to root_path, alert: 'Action Forbidden!'
  end

  def require_admin_or_owner
    return if current_user.admin? || current_user == @user

    redirect_to root_path, alert: 'Action Forbidden!'
  end
end
