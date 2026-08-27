class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are an AI companion inside a note-taking app.
  You will be given the notes stored in the user's current room.

  Use the contents of these notes to answer the user's questions.
  "
  def create
    @citizen = Citizen.find(params[:citizen_id])
    @category = @citizen.category
    @message = Message.new(message_params)
    @message.citizen = @citizen
    @message.role = "user"

    if @message.save
      broadcast_append(@message)
      @assistant_message = Message.create(role: "assistant", content: "", citizen: @citizen)

      broadcast_append(@assistant_message)
      response = ask_llm
      @assistant_message.update(content: response.content)

      # for the corrent order of message display
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to @citizen }
      end

    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("new_message_container", partial: "messages/form",
                                                                            locals: { citizen: @citizen, message: @message })
        end
        format.html { render "citizens/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def ask_llm
    @ruby_llm_citizen = RubyLLM.chat

    build_conversation_history

    @ruby_llm_citizen.with_instructions(instructions).ask(@message.content) do |chunk|
      next if chunk.content.blank? # skip empty chunks

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(@citizen, target: helpers.dom_id(message), partial: "messages/message",
                                                         locals: { message: message })
  end

  def broadcast_append(message)
    Turbo::StreamsChannel.broadcast_append_to(@citizen, target: "chat-field-#{@citizen.id}", partial: "messages/message",
                                                        locals: { message: message })
  end

  def build_conversation_history
    @citizen.messages.each do |message|
      next if message.content.blank?
      next if message.id == @message.id
      next if message.id == @assistant_message.id

      @ruby_llm_citizen.add_message(
        role: message.role,
        content: message.content
      )
    end
  end

  def category_context
    notes = @category.notes

    notes_text = notes.map do |note|
      <<~NOTE
        Note Title: #{note.title}
        Note Content: #{note.content}
      NOTE
    end.join("\n\n")
    <<~CONTEXT
      Current Room: #{@category.name}
      Notes stored inside this room: #{notes_text}

      Use the contents of theses notes to answer the user's questions.
    CONTEXT
  end

  def instructions
    [SYSTEM_PROMPT, category_context].compact.join("\n\n")
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
