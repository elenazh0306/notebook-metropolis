class NotesController < ApplicationController
  def index
    @category = Category.find(params[:category_id])
    @notes = @category.notes
  end

  def show
    @category = Category.find(params[:category_id])
    @note = Note.find(params[:id])
  end

  def new
    @category = Category.find(params[:category_id])
    @note = Note.new
  end

  def create
    @category = Category.find(params[:category_id])
    @note = @category.notes.new(note_params)

    if @note.save
      redirect_to_note_path(@note)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = Category.find(params[:category_id])
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

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
