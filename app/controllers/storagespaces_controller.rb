class StoragespacesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @resource = StorageSpace.new
  end

  def create

    @space = StorageSpace.new(storagespace_params.merge(user_id: current_user))
    # TODO: figure out why the user id is being left as null rather than the user
    # who created the listing.
    @space.save!
    respond_to do |format|
      # TODO: render a form partial here that is prefilled with the ID of the object
      # so that the next part of the browser wizard can update more records in the object.
      format.js { render json: @space, content_type: 'text/json' }
    end
  end

  def storagespace_params
    params.require(:storage_space).permit(:address, :user_id)
  end

  def map
    @json = StorageSpace.all.to_gmaps4rails do |space, marker|
      marker.json({ :id => space.id, :notes => space.notes })
    end
    respond_to do |format|
      format.html
      format.js { render json: @json, content_type: 'text/json' }
    end
  end
end
