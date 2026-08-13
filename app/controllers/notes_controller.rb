class NotesController < ApplicationController
  before_action :set_category
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = @category.notes
  end

  def show
  end

  def new
    @note = @category.notes.build
  end

  def create
    @note = @category.notes.build(note_params)

    if @note.save
      # This line fetches the updated collection, so index.html.erb has @notes
      # See notes in create.turbo_streams.erb for details
      @notes = @category.notes

      respond_to do |format|
        # This is the HTML fallback if Turbo is turned off
        format.html { redirect_to category_notes_path(@category) }
        # Turbo Stream appends the new note or renders index frame
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update

    if @note.update(note_params)
      respond_to do |format|
        # HTML fallback if Turbo is turned off
        format.html { redirect_to category_note_path(@category, @note) }
        # Turbo Stream renders the index frame sans the deleted note
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy

    # Again, we re-fetch remaining notes so Turbo can render index.html.erb
    @notes = @category.notes

    respond_to do |format|
      # HTML fallback if Turbo is turned off
      format.html { redirect_to category_notes_path(@category) }
      # Turbo Stream renders the index frame sans the deleted note
      format.turbo_stream
    end
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def set_note
    @note = @category.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
