class NotesController < ApplicationController
  before_action :set_category
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = @category.notes

    # Filter notes by subfolder
    @subfolder = params[:subfolder] || "notice_board" # Set notice_board as default just in case
    # We re-fetch remaining notes (based on the subfolder) so Turbo can render index.html.erb
    @notes = @category.notes.where(subfolder: @subfolder)
    @note = Note.new(subfolder: @subfolder)
  end

  def show
  end

def new
  # Reads params[:subfolder] from the link (e.g. "bookcase")
  # If none is passed, it falls back to "notice_board"
  # This repeats through a lot of actions here, but I didn't make
  # a before_action, because keeping the code explicit makes it easier to understand
  subfolder_param = params[:subfolder].presence || "notice_board"

  @note = @category.notes.build(subfolder: subfolder_param)
end

  def create
    @note = @category.notes.build(note_params)
    @subfolder = @note.subfolder || "notice_board"

    if @note.save
      # This line fetches the updated collection for THIS subfolder, so index.html.erb has @notes
      # See annotated comments in create.turbo_stream.erb for details
      @notes = @category.notes.where(subfolder: @subfolder).order(created_at: :desc)

      respond_to do |format|
        # This is the HTML fallback if Turbo is turned off (and it preserves subfolder context)
        format.html { redirect_to category_notes_path(@category, subfolder: @subfolder) }
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
      # Capture the subfolder and re-fetch notes for this specific hotspot view
      @subfolder = @note.subfolder || "notice_board"
      @notes = @category.notes.where(subfolder: @subfolder).order(created_at: :desc)

      respond_to do |format|
        # HTML fallback if Turbo is turned off (and again preserves subfolder context)
        format.html { redirect_to category_notes_path(@category, subfolder: @subfolder) }
        # Turbo Stream renders the index frame sans the deleted note
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Capture the subfolder BEFORE destroying the note record! If we don't,
    # @subfolder is set to nil when we use it to define @notes a few lines down
    @subfolder = @note.subfolder || "notice_board"
    @note.destroy

    # We re-fetch remaining notes (based on the subfolder) so Turbo can render index.html.erb
    @notes = @category.notes.where(subfolder: @subfolder)

    respond_to do |format|
      # HTML fallback if Turbo is turned off (and again preserves subfolder context)
      format.html { redirect_to category_notes_path(@category, subfolder: @subfolder) }
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
    params.require(:note).permit(:title, :content, :subfolder)
  end
end
