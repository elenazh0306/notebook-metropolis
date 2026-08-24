class NotesController < ApplicationController
  before_action :set_category
  before_action :set_note, only: %i[show edit update destroy]

  INSTRUCTIONS_FOR_AI_TITLE = "Generate a short descriptive title for the note.
  Keep the title to a maximum of 6 words and only return the title."

  def index
    @notes = @category.notes

    # Filter notes by subfolder
    @hotspot_type = params[:hotspot_type] || "notice_board" # Set notice_board as default just in case
    # We re-fetch remaining notes (based on the subfolder) so Turbo can render index.html.erb
    @notes = @category.notes.where(hotspot_type: @hotspot_type)
    @note = Note.new(hotspot_type: @hotspot_type)
  end

  def show
  end

  def new
    # Reads params[:hotspot_type] from the link (e.g. "bookcase")
    # If none is passed, it falls back to "notice_board"
    # This repeats through a lot of actions here, but I didn't make
    # a before_action, because keeping the code explicit makes it easier to understand
    hotspot_type_param = params[:hotspot_type].presence || "notice_board"

    @note = @category.notes.build(hotspot_type: hotspot_type_param)
  end

  def create
    @note = @category.notes.build(note_params)
    @hotspot_type = @note.hotspot_type || "notice_board"

    generate_ai_title if params[:ai_generated] == "true"

    if @hotspot_type == 'street'

      categories = Category.all
      if @note.save
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.refresh(request_id: nil) }
          format.html { redirect_to categories_path }
        end
      end
    elsif @note.save
      @notes = @category.notes.where(hotspot_type: @hotspot_type).order(created_at: :desc)

      respond_to do |format|
        # This is the HTML fallback if Turbo is turned off (and it preserves hotspot_type context)
        format.html { redirect_to category_notes_path(@category, hotspot_type: @hotspot_type) }
        # Turbo Stream appends the new note or renders index frame
        format.turbo_stream
      end
    # This line fetches the updated collection for THIS hotspot_type, so index.html.erb has @notes
    # See annotated comments in create.turbo_stream.erb for details
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    original_hotspot_type = @note.hotspot_type
    trash_category = @note.category

    if @note.update(note_params)
      if trash_category != @note.category && trash_category.notes.empty?
        trash_category.destroy
      end
      @category = @note.category

      if original_hotspot_type == "street"

        respond_to do |format|

          format.html { redirect_to categories_path, status: :see_other }
          format.turbo_stream { redirect_to categories_path }
        end


      else
        @hotspot_type = @note.hotspot_type || "notice_board"
        @notes = @category.notes.where(hotspot_type: @hotspot_type).order(created_at: :desc)

        respond_to do |format|
          # HTML fallback if Turbo is turned off (and again preserves hotspot_type context)
          format.html { redirect_to category_notes_path(@category, hotspot_type: @hotspot_type) }
          # Turbo Stream renders the index frame sans the deleted note
          format.turbo_stream
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end

  end

  def destroy
    # Capture the hotspot_type BEFORE destroying the note record! If we don't,
    # @hotspot_type is set to nil when we use it to define @notes a few lines down
    @hotspot_type = @note.hotspot_type || "notice_board"
    @note.destroy

    # We re-fetch remaining notes (based on the hotspot_type) so Turbo can render index.html.erb
    @notes = @category.notes.where(hotspot_type: @hotspot_type)

    respond_to do |format|
      # HTML fallback if Turbo is turned off (and again preserves hotspot_type context)
      format.html { redirect_to category_notes_path(@category, hotspot_type: @hotspot_type) }
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
    params.require(:note).permit(:title, :content, :hotspot_type, :category_id)
  end

  def generate_ai_title
    @ruby_llm_chat = RubyLLM.chat

    title = @ruby_llm_chat.with_instructions(INSTRUCTIONS_FOR_AI_TITLE).ask(@note.content)

    @note.title = title.content.strip
  end
end
