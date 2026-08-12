class NotesController < ApplicationController
  before_action :set_category

  def index
    @notes = @category.notes
  end

  def show
    @note = @category.notes.find(params[:id])
  end

  def new
    @note = Note.new
  end

  def create
    @note = @category.notes.new(note_params)

    if @note.save
      redirect_to_note_path(@note)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    if @note.update(note_params)
      redirect_to category_note_path(@category, @note)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy

    redirect_to notes_path
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
