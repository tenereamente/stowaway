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
    @space = Space.create!(params.require(:space).permit(:notes, :address1, :address2, :city, :state, :zip, :country).merge(user_id: current_user.id))
    redirect_to spaces_path
  end

  def show
    @space = Space.find(params[:id])
  end

  def edit
    @resource = Space.find(params[:id])
  end

  def update
    @space = Space.find(params[:id])
    if @space.update_attributes(params.require(:space).permit(:notes, :address1, :address2, :city, :state, :zip, :country, :photo))
      redirect_to spaces_path, :notice => "Space updated."
    else
      redirect_to spaces_path, :alert => "Unable to update space."
    end
  end

  def destroy
    space = Space.find(params[:id])
    space.destroy
    redirect_to spaces_path, :notice => "Space deleted."
  end

end
