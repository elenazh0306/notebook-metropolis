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
    return head :bad_request unless
      tile_map[src_y] &&
      tile_map[tgt_y] &&
      tile_map[src_y][src_x] &&
      tile_map[tgt_y][tgt_x]

    ActiveRecord::Base.transaction do

      #  Find categories attached to the source and target coordinates
      source_category = current_user.categories.find_by(x: src_x, y: src_y)
      target_category = current_user.categories.find_by(x: tgt_x, y: tgt_y)
      is_trash = source_category&.name == "trash"
      is_target_empty = target_category.nil?

      if is_trash && is_target_empty
        source_category.update!(x: tgt_x, y: tgt_y)
      end
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "tile_#{src_x}_#{src_y}",
            partial: "tile_maps/tile",
            locals: { x: src_x, y: src_y, tile_map: current_user.tile_map }
          ),
          turbo_stream.replace(
            "tile_#{tgt_x}_#{tgt_y}",
            partial: "tile_maps/tile",
            locals: { x: tgt_x, y: tgt_y, tile_map: current_user.tile_map }
          )
        ]
      end
      format.html { redirect_back fallback_location: root_path }
    end
  end
end
