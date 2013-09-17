class SpacesController < ApplicationController
  def index
    @spaces = Space.all
  end
  def new
    @resource = Space.new
  end
  def create
    @space = Space.create!(params.require(:space).permit(:notes, :address1, :address2, :city, :state, :zip))
    render 'show'
  end

  def show
    @space = Space.find(params[:id])
  end

  def map
  	@json = Space.all.to_gmaps4rails do |space, marker|
      marker.json({ :id => space.id, :notes => space.notes })
    end
    respond_to do |format|
      format.html
      format.js { render json: @json, content_type: 'text/json' }
    end
  end
end
