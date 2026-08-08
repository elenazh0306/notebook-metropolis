class MessagesController < ApplicationController
  SYSTEM_PROMPT = ""

  def create
    @citizen = Citizen.find(params[:citizen_id])
    @category = @citizen.category
    @message = Message.new(message_params)
    @message.citizen = @citizen
    @message.role = "user"

    if @message.save
      @assistant_message = Message.create(role: "assistant", content: "", citizen: @citizen)

      response = ask_llm
      @assistant_message.update(content: response.content)

      # for the corrent order of message display
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @citizen }
      end

    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("new_message_container", partial: "messages/form", locals: { citizen: @citizen, message: @message }) }
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
    Turbo::StreamsChannel.broadcast_replace_to(@citizen, target: helpers.dom_id(message), partial: "messages/message", locals: { message: message })
  end

  def build_conversation_history
    @citizen.messages.each do |message|
      next if message.content.blank?
      @ruby_llm_citizen.add_message(
        role: message.role,
        content: message.content
      )
    end
  end

  def category_context
    "Here is the context of this category: #{@category.notes.pluck(:content).join(', ')}."
  end

  def instructions
    [SYSTEM_PROMPT, category_context].compact.join("\n\n")
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
