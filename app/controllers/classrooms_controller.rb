class ClassroomsController < ApplicationController
  before_action :set_classroom, only: %i[show edit update destroy]

  def index
    @classrooms = Classroom.all
  end

  def show; end

  def new
    @classroom = Classroom.new
  end

  def create
    @classroom = Classroom.new(classroom_params)

    respond_to do |format|
      if @classroom.save
        flash.now[:notice] = 'Classroom created'

        format.turbo_stream
        format.html { redirect_to classrooms_path, notice: 'Classroom was created' }
      else
        render_turbo_stream_error

        format.turbo_stream
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @classroom.update(classroom_params)
        flash.now[:notice] = 'Classroom was updated'
        format.turbo_stream
        format.html { redirect_to classrooms_path, notice: 'Classroom was updated' }
      else
        render_turbo_stream_error
        format.turbo_stream
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @classroom.destroy
    flash.now[:notice] = 'Classroom was deleted'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@classroom),
          prepend_flash
        ]
      end
      format.html { redirect_to classrooms_path, notice: 'Classroom was deleted' }
    end
  end

  private

  def set_classroom
    @classroom = Classroom.find(params[:id])
  end

  def classroom_params
    params.require(:classroom).permit(:name)
  end

  def render_turbo_stream_error
    flash.now[:alert] = @classroom.errors.full_messages.join('; ')
  end
end
