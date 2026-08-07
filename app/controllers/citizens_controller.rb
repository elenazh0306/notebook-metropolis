class CitizensController < ApplicationController
  before_action :set_category, only: %i[create destroy]
  before_action :citizen, only: %i[show destroy]

  def create
    @citizen = Citizen.new(name: Citizen::DEFAULT_NAME)
    @citizen.category = @category
    if @citizen.save
      redirect_to citizen_path(@citizen)
    else
      @category.citizens = @citizens
      render "categories/show", status: :unprocessable_entity
    end
  end

  def show
    @category = @citizen.category
    @messages = @citizen.messages
    @message = Message.new
  end

  def destroy
    @citizen.destroy
    redirect_to category_path(@category), status: :see_other
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def citizen
    @citizen = Citizen.find(params[:id])
  end
end
