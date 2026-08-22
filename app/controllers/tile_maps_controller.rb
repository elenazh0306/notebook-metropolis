class TileMapsController < ApplicationController
  def update
    @categories = current_user.categories
    x = params[:x].to_i
    y = params[:y].to_i

    new_type = params[:new_type]

    # Notify Rails that tile_map changed
    current_user.tile_map_will_change!
    current_user.tile_map[y][x] = new_type
    current_user.save!

    # Respond with Turbo Stream to swap the DOM element
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "tile_#{x}_#{y}",
          partial: "tile_maps/tile",
          locals: { x: x, y: y, tile_map: current_user.tile_map }
        )
      end
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def swap
    source_params = params.require(:source).permit(:x, :y)
    target_params = params.require(:target).permit(:x, :y)

    src_x, src_y = source_params[:x].to_i, source_params[:y].to_i
    tgt_x, tgt_y = target_params[:x].to_i, target_params[:y].to_i

    tile_map = current_user.tile_map

    # Ensure coordinates are within grid bounds
    return head :bad_request unless tile_map[src_y] && tile_map[tgt_y]

    ActiveRecord::Base.transaction do
      # 1. Swap the underlying tile terrain strings in the JSON/Array matrix
      src_type = tile_map[src_y][src_x]
      tgt_type = tile_map[tgt_y][tgt_x]

      current_user.tile_map_will_change!
      current_user.tile_map[src_y][src_x] = tgt_type
      current_user.tile_map[tgt_y][tgt_x] = src_type
      current_user.save!

      # 2. Find categories attached to the source and target coordinates
      source_category = current_user.categories.find_by(x: src_x, y: src_y)
      target_category = current_user.categories.find_by(x: tgt_x, y: tgt_y)

      # 3. Swap category coordinates so buildings move with their tiles
      # Use temporary coordinates (-1, -1) to bypass unique coordinate validations if present
      if source_category && target_category
        source_category.update!(x: -1, y: -1)
        target_category.update!(x: src_x, y: src_y)
        source_category.update!(x: tgt_x, y: tgt_y)
      elsif source_category
        source_category.update!(x: tgt_x, y: tgt_y)
      elsif target_category
        target_category.update!(x: src_x, y: src_y)
      end
    end

    # Set variables for the Turbo Stream response
    @src_x, @src_y = src_x, src_y
    @tgt_x, @tgt_y = tgt_x, tgt_y

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "tile_#{@src_x}_#{@src_y}",
          partial: "tile_maps/tile",
          locals: { x: x, y: y, tile_map: current_user.tile_map }
        )
        render turbo_stream: turbo_stream.replace(
          "tile_#{@tgt_x}_#{@tgt_y}",
          partial: "tile_maps/tile",
          locals: { x: x, y: y, tile_map: current_user.tile_map }
        )
      end
      format.html { redirect_back fallback_location: root_path }
    end
  end

end
