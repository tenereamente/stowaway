class SpacesController < ApplicationController
  def index
    puts params
    if params[:user_id].present?
      @spaces = Space.by_user(params[:user_id].to_i)
    elsif params[:tag].present? 
      @spaces = Space.owned.tagged_with(params[:tag])
    else 
      @spaces = Space.owned.all
    end 
    @json = @spaces.to_gmaps4rails do |space, marker|
      marker.json({ :id => space.id, :notes => space.notes })
    end
  end

  def new
    @resource = Space.new
  end

  def create
    user_id = user_signed_in? ? current_user.id : nil
    @space = Space.create!(params.require(:space).permit(:notes, :address1, :address2, :city, :state, :zip, :country, :tag_list, :email, :available, :complete).merge(user_id: user_id ))
    if user_id
      redirect_to spaces_path
    else
      # TODO gradual registration, take email param and create a user on the fly and log them in.
      redirect_to spaces_path, :alert => "Space created without owner, need to register user"
    end
  end

  def show
    @space = Space.find(params[:id])
    @json = @space.to_gmaps4rails do |space, marker|
      marker.json({ :id => space.id, :notes => space.notes })
    end
  end

  def edit
    @resource = Space.find(params[:id])
  end

  def update
    @space = Space.find(params[:id])
    if @space.update_attributes(params.require(:space).permit(:notes, :address1, :address2, :city, :state, :zip, :country, :photo, :tag_list, :available, :complete))
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
