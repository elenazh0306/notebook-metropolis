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

  end
end
