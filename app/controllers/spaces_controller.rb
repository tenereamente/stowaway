class SpacesController < ApplicationController
  include ApplicationHelper

  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @spaces = Space.by_user(params[:user_id].to_i)
      render 'my_index'
    else
      @spaces = Space.owned.complete.available
      if params[:tag].present?
        @spaces = @spaces.tagged_with(params[:tag])
      end
      if params[:bounds].present?
        # TODO: bounds is a pair of LatLng pairs that form a box, only include addresses inside the box
        # address is ignored, just included in URL to make humans more comfortable, bounds defines the geo bounds
        # http://ngauthier.com/2013/08/postgis-and-rails-a-simple-approach.html
      end
      if params[:environment].present?
        # 'Any' is code for don't filter
        @spaces = @spaces.where('environment LIKE ?',  params[:environment].delete(' ').underscore) unless params[:environment] == 'Any'
      end
      if params[:type].present?
        @spaces = @spaces.where('type LIKE ?',  params[:type].delete(' ').underscore) unless params[:type] == 'Any'
      end
      if params[:access].present?
        @spaces = @spaces.where('access LIKE ?', params[:access].delete(' ').underscore) unless params[:access] == 'Any'
      end
      @spaces = @spaces.load
    end
    @json = @spaces.to_gmaps4rails do |space, marker|
      marker.json({ :id => space.id, :notes => space.notes })
    end
  end

  def new
    @resource = Space.new
  end

  def space_params
    allow = [
      :notes, :address1, :address2, :city, :state, :zip, :country, :tag_list, :email,
      :available, :complete, :type, :environment, :access, :climate_controlled, :lockable, :attended, :length, :width, :height, :units,
      :photo, :photo2, :photo3, :photo4, :photo5, :monthly_price, :title, :type
    ]
    params.require(:space).permit(*allow)
  end

  def create
    if user_signed_in?
      u = current_user
    elsif params[:user_email]
      u = User.find_or_create_by_email({ email: params[:user_email]})
      u.send_confirmation_instructions
    else
      redirect_to new_space_path, :error => "Must be signed in or provide email address to list a space"
    end
    @space = Space.create!(space_params.merge(user_id: u.id))
    redirect_to space_path(@space)
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

    unless can_edit_space?(@space)
      redirect_to space_path(@space), :error => "Don't have permission to edit this space"
    end
    
    if @space.update_attributes(space_params)
      # if this was an update flipping a space to completed status,
      # trigger a customer.io event notification so that the user
      # gets a gorgeous email.
      if should_notify_listing_complete?(space_params)
        listing_url = space_path(@space)
        listing_title = @space.title
        image_count = @space.get_photo_count
        $customerio.track(current_user.id, "listed_space_confirmation", listing_url: listing_url, listing_title: listing_title, listing_image_count: image_count)
      end
      redirect_to space_path(@space), :notice => "Space updated."
    else
      redirect_to edit_space_path(@space), :alert => "Unable to update space."
    end
  end

  def destroy
    space = Space.find(params[:id])
    space.destroy
    redirect_to spaces_path, :notice => "Space deleted."
  end

  def subregion_options
    render partial: 'subregion_select'
  end

  private

  def should_notify_listing_complete?(space_params)
    # if we got an update and it was only setting available and complete
    # to true, this is a case where we want to notify that the listing
    # was completed.
    if space_params.size == 2
      if space_params[:available] == "true"
        if space_params[:complete] == "true"
          return true
        end
      end
    end
    return false
  end

end
