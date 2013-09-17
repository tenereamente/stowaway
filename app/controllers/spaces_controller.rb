class SpacesController < ApplicationController
  def index
    @spaces = Space.all
    @json = Space.all.to_gmaps4rails do |space, marker|
      marker.json({ :id => space.id, :notes => space.notes })
    end
  end
  def new
    @resource = Space.new
  end
  def create
    @space = Space.create!(params.require(:space).permit(:notes, :address1, :address2, :city, :state, :zip, :country))
    render 'show'
  end

  def show
    @space = Space.find(params[:id])
  end

end
