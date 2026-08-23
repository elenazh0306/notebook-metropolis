class CategoriesController < ApplicationController
  def index
    @categories = policy_scope(Category)
    create_map
    @category = Category.new
    @images = User::BUILDINGS
    @rooms = User::ROOMS

    @indexed_tiles = current_user.tile_map.each_with_index.map do |sub_array, index|
                      sub_array.each_with_index.map do |item, sub_index|
                        next if item == "base"
                        { tile: item, row: index, column: sub_index }
                      end.compact
                    end.flatten


  end

  def show
    @category = Category.find(params[:id])
    authorize @category
  end

  def new
    @category = Category.new
    authorize @category
    @images = User::BUILDINGS
  end

  def create
    @category = Category.new(category_params)
    @category.user = current_user
    @category.room_video = User::ROOM_VIDEOS[params[:category][:room_image]]
    @category.building_animation_type = "occasional"
    @note = Note.new
    @images = User::BUILDINGS
    authorize @category

    if @category.name == "trash"
      if @category.save
        respond_to do |format|
          format.html { redirect_to categories_path }
          format.turbo_stream
        end
      end

    else
      if @category.save
        hotspot(@category)
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.refresh(request_id: nil) }
          format.html { redirect_to categories_path }
        end
      else
        respond_to do |format|
          format.html {
            @categories = Category.all
            create_map
            render :index, status: :unprocessable_entity
          }
          format.turbo_stream {
            render turbo_stream: turbo_stream.append(
              "category_new_form",
              partial: "shared/errors",
              locals: { object: @category }
            ), status: :unprocessable_entity
          }
        end
      end
    end


  end

  def edit
    @category = Category.find(params[:id])
    authorize @category
  end

  def update
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.update(category_params)
        authorize @category
        format.json { render json: { status: :ok, category: @category } }
        format.html { redirect_to categories_path }
      else
        format.json { render json: @category.errors, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
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
    params.require(:category).permit(:name, :sprite_image, :x, :y, :room_image)
  end

  def create_map
    x = params[:x].to_i
    y = params[:y].to_i
    @row = current_user.tile_map.length
    @column = current_user.tile_map[0].length
    @current_type = current_user.tile_map[y][x].to_s
    @tile = User::TILE_TYPES[@current_type.to_sym]
    @tile_order = User::TILE_TYPES.keys.map(&:to_s)
    @category_on_tile = @categories.find { |c| c.x == x && c.y == y }
  end

  def hotspot(category)
    # Corkboard Hotspot
    category.notes.create!(
      title: "Corkboard introduction",
      content: "📌 This is your corkboard! Start with your first post-it note right now!",
      hotspot_type: "notice_board"
    )

    # Bookcase Hotspot
    category.notes.create!(
      title: "Library introduction",
      content: "📚 This is your bookshelf! Do you know the best part? You are the author of all of them!",
      hotspot_type: "bookcase"
    )

    # Laptop Hotspot
    category.notes.create!(
      title: "Terminal Workspace Logs",
      content: "💾 Time to enter the matrix! Start your journey right now!",
      hotspot_type: "laptop"
    )

    # Posters Hotspot
    category.notes.create!(
      title: "Inspirational Quote",
      content: "🌠 Turn your pictures into motivational posts! Just! Do! It!",
      hotspot_type: "posters"
    )


  end
end
