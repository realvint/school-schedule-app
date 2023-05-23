class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def prepend_flash
    turbo_stream.prepend(:flash, partial: 'shared/flash')
  end

  helper_method :prepend_flash
end
