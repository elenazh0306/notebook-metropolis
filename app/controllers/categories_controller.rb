class CategoriesController < ApplicationController
   def index
    @categories = policy_scope(Category)
  end

  def show
    @category = Category.find(params[:id])
    authorize @category
  end

  def new
    @category = Category.new
    authorize @category
  end

  def create
    @category = Category.new(category_params)
    category.user = current_user
    authorize @category

    if @category.save
      redirect_to category_path(@category)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = Category.find(params[:id])
    authorize @category
  end

  def update
    authorize @category
    if @category.update(category_params)
      redirect_to category_path(@category)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    authorize @category
    @category.destroy

    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
