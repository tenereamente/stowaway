class SpacesController < ApplicationController
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
        # 'All' is code for don't filter
        @spaces = @spaces.where('environment LIKE ?',  params[:environment].downcase) unless params[:environment] == 'All'
      end
      if params[:type].present?
        @spaces = @spaces.where('type LIKE ?',  params[:type].downcase) unless params[:type] == 'All'
      end
      if params[:access].present?
        @spaces = @spaces.where('access LIKE ?', params[:access].downcase) unless params[:access] == 'All'
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
    space_confirm = params[:available] == true
    if @space.update_attributes(space_params)
      listing_title = @space.title
      listing_url = space_path(@space)
      "listed_space_confirmation"
      # send listed_space_Confirmation trigger.
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

end
