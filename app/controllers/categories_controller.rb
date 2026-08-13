class CategoriesController < ApplicationController
  def index
    @categories = policy_scope(Category)
    x = params[:x].to_i
    y = params[:y].to_i
    @row = current_user.tile_map.length

    @column = current_user.tile_map[0].length
    @current_type = current_user.tile_map[y][x].to_s
    @tile = User::TILE_TYPES[@current_type.to_sym]
    @tile_order = User::TILE_TYPES.keys.map(&:to_s)
    @category_on_tile = @categories.find { |c| c.x == x && c.y == y }


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
    @category.user = current_user
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
    if @category.update(category_params)
      authorize @category
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
