class CategoriesController < ApplicationController
  def index
    @categories = policy_scope(Category)
  end

  def show
    authorize @category
    @category = Category.find(params[:id])
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
    authorize @category
    @category = Category.find(params[:id])
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
    authorize @category
    @category = Category.find(params[:id])
    @category.destroy

    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).require(:name, :summary)
  end
end
